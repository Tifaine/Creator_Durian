#include "gestionstrategie.h"
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

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

int GestionStrategie::getNbEtape()
{
    return listEtape.size();
}
