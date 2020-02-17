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

void GestionStrategie::removeEtape(Etape * etape)
{
    listEtape.removeOne(etape);
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
        saveFile.resize(0);
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
        saveFile.resize(0);
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
            QJsonArray arraySequence = exportSequence(item->getNameSequence());
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

int GestionStrategie::appendSequence(QString filename, EditableAction* blocSequenceToOpen)
{
    int toReturn = 0;
    QFile loadFile("data/Sequence/"+ filename);
    if(!loadFile.open(QIODevice::ReadOnly))
    {
        qDebug()<<"Failed export sequence ! "<<filename;
    }else
    {
        QByteArray saveData = loadFile.readAll();
        QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));
        QJsonObject json = loadDoc.object();
        int indiceDepart = listAction.size();
        if(json.contains("sequence"))
        {
            if( json["sequence"].isArray())
            {
                QJsonArray array = json["sequence"].toArray();
                foreach (const QJsonValue & v, array)
                {
                    listAction.append(new EditableAction);
                    toReturn++;
                    listAction.last()->open1(v.toObject());
                }
                int indice = 0;
                foreach (const QJsonValue & v, array)
                {
                    listAction.at(indiceDepart+indice)->open2(v.toObject());
                    for(int i = 0; i < listAction.at(indiceDepart+indice)->getNbfille(); i++)
                    {
                        listAction.at(indiceDepart+indice)->addGirlToFatherForExport(listAction.at(indiceDepart + listAction.at(indiceDepart + indice)->getIndicefille(i)));
                    }
                    for(int i = 0; i < listAction.at(indiceDepart+indice)->getNbTimeout(); i++)
                    {
                        listAction.at(indiceDepart+indice)->addGirlToTimeoutForExport(listAction.at(indiceDepart + listAction.at(indiceDepart + indice)->getIndiceTimeout(i)));
                    }
                    indice++;
                }
                for(int i = indiceDepart; i < listAction.size(); i++)
                {
                    if(listAction.at(i)->getNomAction() == "Sequence")
                    {
                        int toAdd = appendSequence(listAction.at(i)->getValueDefaultParam(0), (listAction.at(i)));
                        i+= toAdd;

                    }else if(listAction.at(i)->getNomAction() == "Fin" && blocSequenceToOpen != NULL)
                    {
                        for(int indice = 0; indice < blocSequenceToOpen->getNbfille(); indice++)
                        {
                            listAction.at(i)->addGirlToFatherForExport(blocSequenceToOpen->getListFille().at(indice));
                        }
                    }
                }
                for(int i = indiceDepart; i < listAction.size(); i++)
                {
                    if(listAction.at(i)->getNomAction() == "Départ" && blocSequenceToOpen != NULL)
                    {
                        blocSequenceToOpen->clearListFille();
                        blocSequenceToOpen->addGirlToFatherForExport(listAction.at(i));
                    }
                }
            }
        }
    }
    return toReturn;
}

QJsonArray GestionStrategie::exportSequence(QString filename)
{
    QJsonObject saveObject;
    QJsonArray arraySequence;
    appendSequence(filename, NULL);
    for(auto item : listAction)
    {
        QJsonObject saveObject;
        QJsonArray arrayParam;
        QString nomParam("nomParam");
        QString defaultValue("defaultValue");
        for(int i = 0; i < item->getNbParam(); i++)
        {
            QJsonObject item_data;
            item_data.insert(nomParam, QJsonValue(item->getNomParam(i)));
            item_data.insert(defaultValue, QJsonValue(item->getValueDefaultParam(i)));
            arrayParam.push_back(QJsonValue(item_data));
        }

        QJsonArray arrayPere;
        QString indicePere("indicePere");
        for(int i = 0; i < item->getListPere().size(); i++)
        {
            QJsonObject item_daddy;
            item_daddy.insert(indicePere, listAction.indexOf(item->getListPere().at(i)));
            arrayPere.push_back(QJsonValue(item_daddy));
        }

        QJsonArray arrayFille;
        QString indiceFille("indiceFille");
        for(int i = 0; i < item->getListFille().size(); i++)
        {
            QJsonObject item_girl;
            item_girl.insert(indiceFille, listAction.indexOf(item->getListFille().at(i)));
            arrayFille.push_back(QJsonValue(item_girl));
        }

        QJsonArray arrayTimeout;
        QString indiceTimeout("indiceTimeout");
        for(int i = 0; i < item->getListTimeOut().size(); i++)
        {
            QJsonObject item_timeout;
            item_timeout.insert(indiceTimeout, listAction.indexOf(item->getListTimeOut().at(i)));
            arrayTimeout.push_back(QJsonValue(item_timeout));
        }
        saveObject["arrayDaddy"] = arrayPere;
        saveObject["arrayGirl"] = arrayFille;
        saveObject["arrayTimeout"] = arrayTimeout;
        saveObject["arrayParam"] = arrayParam;
        saveObject["blocante"] = item->getIsActionBlocante();
        saveObject["indice"] = listAction.indexOf(item);
        saveObject["xBloc"] = item->getXBloc();
        saveObject["yBloc"] = item->getYBloc();
        saveObject["nomAction"] = item->getNomAction();
        arraySequence.push_back(QJsonValue(saveObject));
    }
    return arraySequence;
}
