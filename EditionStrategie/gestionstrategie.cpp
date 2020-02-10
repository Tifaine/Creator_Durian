#include "gestionstrategie.h"
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

#define NB_MAX_ACTIONS   500

GestionStrategie::GestionStrategie(QObject *parent) : QObject(parent)
{

}

void GestionStrategie::addEtape(Etape * etape)
{
    listEtape.append(etape);
}

Etape* GestionStrategie::getEtape(int indice)
{
    if(indice < listEtape.size())
    {
        return listEtape.at(indice);
    }
    return NULL;
}

Etape* GestionStrategie::getEtape(Etape * step)
{
    return listEtape.at(listEtape.indexOf(step));
}

void GestionStrategie::clearList()
{
    listEtape.clear();
}

void GestionStrategie::saveStrategie(QString nomFile)
{
    QFile saveFile("data/Strategie/"+ nomFile +".json");
    if(!saveFile.open(QIODevice::ReadWrite))
    {
        qDebug()<<"Failed !";
    }else
    {
        saveFile.flush();
        QJsonObject saveObject;
        QJsonArray arrayStrat;
        for(auto item : listEtape)
        {
            arrayStrat.push_back(QJsonValue(item->saveEtape()));
        }


        saveObject["Strategie"] = arrayStrat;
        QJsonDocument saveDoc(saveObject);
        saveFile.write(saveDoc.toJson());

        saveFile.close();
    }
}

void GestionStrategie::updateStrat()
{
    QDir dir("data/Strategie");
    QStringList filters;
    filters << "*.json";
    dir.setNameFilters(filters);
    QFileInfoList list = dir.entryInfoList();
    listStrat.clear();
    for (int i = 0 ; i < list.size() ; i++)
    {
        listStrat.append(list.at(i).fileName().left(list.at(i).fileName().length()-5));
    }
}

int GestionStrategie::getNbStrat()
{
    return listStrat.size();
}

QString GestionStrategie::getNameStrat(int indice)
{
    return listStrat.at(indice);
}

void GestionStrategie::openStrat(QString nomStrat)
{
    listEtape.clear();
    QFile loadFile("data/Strategie/"+nomStrat+".json");
    if(!loadFile.open(QIODevice::ReadOnly))
    {
        qDebug()<<"Failed !";
    }else
    {
        QByteArray saveData = loadFile.readAll();
        QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));
        QJsonObject json = loadDoc.object();
        if (json.contains("Strategie") )
        {
            if(json["Strategie"].isArray())
            {
                QJsonArray array = json["Strategie"].toArray();
                int indice = 0;
                foreach (const QJsonValue & v, array)
                {
                    Etape foo;
                    foo.loadObject(v.toObject());
                    emit nouvelleEtape(foo.getNomEtape(), foo.getNbPoints(), foo.getTempsMoyen(), foo.getTempsMax(), foo.getDateMax(), foo.getDeadline(), foo.getX(), foo.getY(), foo.getColor(), foo.getNameSequence());

                    for(int i=0; i<foo.getNbTaux();i++)
                    {
                        emit nouveauTaux(indice, foo.getParamTaux(i), foo.getCondTaux(i), foo.getValueTaux(i), foo.getRatioTaux(i));
                    }
                    indice++;
                }
            }
        }
    }
}

void GestionStrategie::exportStrat()
{
    QFile saveFile("data/export.json");
    if(!saveFile.open(QIODevice::ReadWrite))
    {
        qDebug()<<"Failed !";
    }else
    {
        saveFile.flush();
        QJsonObject saveObject;
        QJsonArray arrayStrat;
        int nbSequence = 0;
        for(auto item : listEtape)
        {
            QJsonObject saveObjectEtape;
            saveObjectEtape["nomEtape"] = item->getNomEtape();
            saveObjectEtape["nbPoints"] = item->getNbPoints();
            saveObjectEtape["tempsMoyen"] = item->getTempsMoyen();
            saveObjectEtape["tempsMax"] = item->getTempsMax();
            saveObjectEtape["dateMax"] = item->getDateMax();
            saveObjectEtape["deadline"] = item->getDeadline();
            saveObjectEtape["color"] = item->getColor();
            QJsonArray arraySequence;
            exportSequence(item->getNameSequence(), &arraySequence, nbSequence, &nbSequence, 0, NULL);
            saveObjectEtape["arraySequence"] = arraySequence;
            nbSequence++;
            saveObjectEtape["xEtape"] = item->getX();
            saveObjectEtape["yEtape"] = item->getY();

            QJsonArray array_Taux;
            QString param("param");
            QString condition("condition");
            QString valeur("valeur");
            QString taux("taux");
            for(int i = 0; i < item->getNbTaux(); i++)
            {
                QJsonObject item_data;
                item_data.insert(param, QJsonValue(item->getParamTaux(i)));
                item_data.insert(condition, QJsonValue(item->getCondTaux(i)));
                item_data.insert(valeur, QJsonValue(item->getValueTaux(i)));
                item_data.insert(taux, QJsonValue(item->getRatioTaux(i)));

                array_Taux.push_back(QJsonValue(item_data));
            }

            saveObject["TauxArray"] = array_Taux;
            arrayStrat.push_back(QJsonValue(saveObjectEtape));
        }

        saveObject["Strategie"] = arrayStrat;
        QJsonDocument saveDoc(saveObject);
        saveFile.write(saveDoc.toJson());

        saveFile.close();
    }
}

int GestionStrategie::getNbEtape()
{
    return listEtape.size();
}

void GestionStrategie::exportSequence(QString filename, QJsonArray* saveObjectEtape, int nbSequence, int* nbSequenceToReturn, int numeroSequence, QJsonArray* arrayFilleParent)
{
    QFile loadFile("data/Sequence/"+ filename);
    if(!loadFile.open(QIODevice::ReadOnly))
    {
        qDebug()<<"Failed export sequence ! "<<filename;
    }else
    {
        QByteArray saveData = loadFile.readAll();
        QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));
        QJsonObject json = loadDoc.object();
        if(json.contains("sequence"))
        {
            if( json["sequence"].isArray())
            {
                QJsonArray array = json["sequence"].toArray();
                foreach (const QJsonValue & v, array)
                {
                    QJsonObject saveObject;
                    QJsonObject objectEditAction = v.toObject();
                    if(objectEditAction.contains("nomAction") )
                    {
                        saveObject["nomAction"] = objectEditAction["nomAction"];


                        if(saveObject["nomAction"].toString() == "Sequence")
                        {
                            QJsonArray arrayFille;
                            if(objectEditAction.contains("arrayGirl") )
                            {
                                QString indiceFille("indiceFille");

                                QJsonArray array = objectEditAction["arrayGirl"].toArray();

                                foreach (const QJsonValue & v, array)
                                {
                                    QJsonObject obj = v.toObject();
                                    if(obj.contains("indiceFille") )
                                    {
                                        QJsonObject item_girl;
                                        item_girl.insert(indiceFille, obj["indiceFille"].toInt() + NB_MAX_ACTIONS*(nbSequence));
                                        arrayFille.push_back(QJsonValue(item_girl));
                                    }
                                }
                            }
                            QJsonArray array = objectEditAction["arrayParam"].toArray();
                            foreach (const QJsonValue & v, array)
                            {
                                QJsonObject obj = v.toObject();
                                (*nbSequenceToReturn)++;
                                exportSequence(obj["defaultValue"].toString(), saveObjectEtape, nbSequence+1, nbSequenceToReturn, objectEditAction["indice"].toInt()+ 500*(nbSequence), &arrayFille);
                            }


                        }else if (saveObject["nomAction"].toString() == "Fin")
                        {
                            saveObject["indice"] = objectEditAction["indice"].toInt() + NB_MAX_ACTIONS*(nbSequence);
                            if(arrayFilleParent != NULL)
                                saveObject["arrayGirl"] = *arrayFilleParent;
                        }else
                        {
                            if (saveObject["nomAction"].toString() == "Départ")
                            {
                                saveObject["indice"] = numeroSequence;
                            }else
                            {
                                saveObject["indice"] = objectEditAction["indice"].toInt() + NB_MAX_ACTIONS*(nbSequence);
                            }
                            if(objectEditAction.contains("blocante") )
                            {
                                saveObject["blocante"] = objectEditAction["blocante"];
                            }
                            if(objectEditAction.contains("arrayParam") )
                            {
                                saveObject["arrayParam"] = objectEditAction["arrayParam"];
                            }
                            QJsonArray arrayTimeout;
                            QJsonArray arrayFille;
                            if(objectEditAction.contains("arrayGirl") )
                            {
                                QString indiceFille("indiceFille");

                                QJsonArray array = objectEditAction["arrayGirl"].toArray();

                                foreach (const QJsonValue & v, array)
                                {
                                    QJsonObject obj = v.toObject();
                                    if(obj.contains("indiceFille") )
                                    {
                                        QJsonObject item_girl;
                                        item_girl.insert(indiceFille, obj["indiceFille"].toInt() + NB_MAX_ACTIONS*(nbSequence));
                                        arrayFille.push_back(QJsonValue(item_girl));
                                    }
                                }
                            }
                            if(objectEditAction.contains("arrayTimeout") )
                            {
                                QString indiceTimeout("indiceTimeout");

                                QJsonArray array = objectEditAction["arrayTimeout"].toArray();
                                foreach (const QJsonValue & v, array)
                                {
                                    QJsonObject obj = v.toObject();
                                    if(obj.contains("indiceTimeout") )
                                    {
                                        QJsonObject item_indiceTimeout;
                                        item_indiceTimeout.insert(indiceTimeout, obj["indiceTimeout"].toInt() + NB_MAX_ACTIONS*(nbSequence));
                                        arrayTimeout.push_back(QJsonValue(item_indiceTimeout));
                                    }
                                }
                            }
                            saveObject["arrayGirl"] = arrayFille;
                            saveObject["arrayTimeout"] = arrayTimeout;
                        }
                        saveObjectEtape->push_back(QJsonValue(saveObject));
                    }
                }

            }
        }
    }
}
