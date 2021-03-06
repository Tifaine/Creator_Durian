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

void GestionStrategie::addPosition(Position * position)
{
    listPosition.append(position);
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
    listPosition.clear();
}

void GestionStrategie::saveStrategie(QString nomFile)
{
    QFile saveFile("data/Strategie/"+ nomFile +".json");
    if(!saveFile.open(QIODevice::ReadWrite))
    {
        qDebug()<<"Failed ! "<<Q_FUNC_INFO;
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
    emit clearAllLists();
    listPosition.clear();
    listEtape.clear();
    QFile loadFile("data/Strategie/"+nomStrat);
    if(!loadFile.open(QIODevice::ReadOnly))
    {
        qDebug()<<"Failed ! "<<Q_FUNC_INFO;
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
        if(json.contains("Position"))
        {
            if(json["Position"].isArray())
            {
                QJsonArray array = json["Position"].toArray();
                foreach (const QJsonValue & v, array)
                {
                    QJsonObject jsonPos = v.toObject();
                    int x, y;
                    x = y = 0;
                    if(jsonPos.contains("xPosition") && jsonPos.contains("yPosition"))
                    {
                        x = jsonPos["xPosition"].toInt();
                        y = jsonPos["yPosition"].toInt();
                    }
                    emit nouvellePosition(x, y);
                }

                foreach (const QJsonValue & v, array)
                {
                    QJsonObject jsonPos = v.toObject();
                    int indicePosition = -1;
                    if(jsonPos.contains("indicePosition"))
                    {
                        indicePosition = jsonPos["indicePosition"].toInt();
                    }
                    if(jsonPos.contains("PosLieeArray") )
                    {
                        QJsonArray array = jsonPos["PosLieeArray"].toArray();
                        foreach (const QJsonValue & w, array)
                        {
                            QJsonObject obj = w.toObject();
                            listPosition.at(indicePosition)->addPositionLiee(listPosition.at(obj.value("indicePosLiee").toInt()));
                        }
                    }
                    if(jsonPos.contains("EtapeLieeArray") )
                    {
                        QJsonArray array = jsonPos["EtapeLieeArray"].toArray();
                        foreach (const QJsonValue & w, array)
                        {
                            QJsonObject obj = w.toObject();
                            listPosition.at(indicePosition)->addEtapeLiee(listEtape.at(obj.value("indiceEtapeLiee").toInt()));
                        }
                    }
                }
            }
            emit updateAllLiaison();
        }
        if (json.contains("Strategie") )
        {
            if(json["Strategie"].isArray())
            {
                QJsonArray array = json["Strategie"].toArray();
                int indice = 0;
                foreach (const QJsonValue & v, array)
                {
                    QJsonObject jsonStep = v.toObject();
                    if(jsonStep.contains("PosLieeArray") )
                    {
                        QJsonArray array = jsonStep["PosLieeArray"].toArray();
                        foreach (const QJsonValue & w, array)
                        {
                            QJsonObject obj = w.toObject();
                            listEtape.at(indice)->addPositionLiee(listPosition.at(obj.value("indicePosLiee").toInt()));
                        }
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
        qDebug()<<"Failed ! "<<Q_FUNC_INFO;
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
            saveObjectEtape["indiceEtape"] = listEtape.indexOf(item);
            saveObjectEtape["nbPoints"] = item->getNbPoints();
            saveObjectEtape["tempsMoyen"] = item->getTempsMoyen();
            saveObjectEtape["tempsMax"] = item->getTempsMax();
            saveObjectEtape["dateMax"] = item->getDateMax();
            saveObjectEtape["deadline"] = item->getDeadline();
            saveObjectEtape["color"] = item->getColor();
            mapIndice.clear();
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

            saveObjectEtape["TauxArray"] = array_Taux;
            QJsonArray arrayPositionLiee;
            QString indicePosLiee("indicePosLiee");
            for(int i = 0; i < item->getNbPositionLiee(); i++)
            {
                QJsonObject item_data;
                item_data.insert(indicePosLiee, QJsonValue( listPosition.indexOf(item->getPosition(i) )));
                arrayPositionLiee.push_back(QJsonValue(item_data));
            }
            saveObjectEtape["PosLieeArray"] = arrayPositionLiee;
            arrayStrat.push_back(QJsonValue(saveObjectEtape));
        }

        QJsonArray arrayPosition;
        for(auto item : listPosition)
        {
            QJsonObject saveObjectPosition;
            saveObjectPosition["indicePosition"] = listPosition.indexOf(item);
            saveObjectPosition["xPosition"] = item->getX();
            saveObjectPosition["yPosition"] = item->getY();

            QJsonArray arrayPositionLiee;
            QString indicePosLiee("indicePosLiee");
            for(int i = 0; i < item->getNbPositionLiee(); i++)
            {
                QJsonObject item_data;
                item_data.insert(indicePosLiee, QJsonValue( listPosition.indexOf(item->getPosition(i) )));
                arrayPositionLiee.push_back(QJsonValue(item_data));
            }
            QJsonArray arrayEtapeLiee;
            QString indiceEtapeLiee("indiceEtapeLiee");
            for(int i = 0; i < item->getNbEtapeLiee(); i++)
            {
                QJsonObject item_data;
                item_data.insert(indiceEtapeLiee, QJsonValue( listEtape.indexOf(item->getEtape(i) )));
                arrayEtapeLiee.push_back(QJsonValue(item_data));
            }

            saveObjectPosition["PosLieeArray"] = arrayPositionLiee;
            saveObjectPosition["EtapeLieeArray"] = arrayEtapeLiee;
            arrayPosition.push_back(QJsonValue(saveObjectPosition));
        }

        saveObject["Strategie"] = arrayStrat;
        saveObject["Position"] = arrayPosition;
        QJsonDocument saveDoc(saveObject);
        saveFile.write(saveDoc.toJson());

        saveFile.close();
    }
}

int GestionStrategie::getNbEtape()
{
    return listEtape.size();
}

int GestionStrategie::appendSequence(QString filename, int indiceSequence)
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
                    if(listAction.last()->getNomAction() == "Départ")
                    {
                        mapIndice[listAction.count()-1] = false;
                    }
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
                        int toAdd = appendSequence(listAction.at(i)->getValueDefaultParam(0), i);
                        i+= toAdd;
                        toReturn += toAdd;

                    }else if(listAction.at(i)->getNomAction() == "Fin" && indiceSequence != -1)
                    {
                        for(int indice = 0; indice < listAction.at(indiceSequence)->getNbfille(); indice++)
                        {
                            listAction.at(i)->addGirlToFatherForExport(listAction.at(indiceSequence)->getListFille().at(indice));
                        }
                    }
                }
                for(int i = indiceDepart; i < listAction.size(); i++)
                {
                    if(listAction.at(i)->getNomAction() == "Départ" && indiceSequence != -1 && mapIndice.contains(i) && !(mapIndice[i]))
                    {
                        mapIndice[i] = true;
                        listAction.at(indiceSequence)->clearListFille();
                        listAction.at(indiceSequence)->addGirlToFatherForExport(listAction.at(i));
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
    appendSequence(filename, -1);
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
