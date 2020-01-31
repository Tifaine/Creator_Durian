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
    listEtape.append(new Etape);

    listEtape.last()->setNomEtape(etape->getNomEtape());
    listEtape.last()->setNbPoints(etape->getNbPoints());
    listEtape.last()->setTempsMoyen(etape->getTempsMoyen());
    listEtape.last()->setTempsMax(etape->getTempsMax());
    listEtape.last()->setDateMax(etape->getDateMax());
    listEtape.last()->setDeadline(etape->getDeadline());
    listEtape.last()->setColor(etape->getColor());
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
    qDebug()<<"Ici "<<listEtape.indexOf(step);
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
