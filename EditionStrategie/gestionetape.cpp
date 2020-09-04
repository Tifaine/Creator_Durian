#include "gestionetape.h"
#include <QDebug>
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

GestionEtape::GestionEtape(QObject *parent) : QObject(parent)
{
    updateEtape();
}

void GestionEtape::addEtape(Etape* etape)
{
    listEtape.append(etape);
}

Etape* GestionEtape::getEtape(int indice)
{
    return listEtape.at(indice);
}

QString GestionEtape::getNomEtape(int indice)
{
    return getEtape(indice)->getNomEtape();
}

int GestionEtape::getNbPointEtape(int indice)
{
    return getEtape(indice)->getNbPoints();
}

int GestionEtape::getTempsMoyenEtape(int indice)
{
    return getEtape(indice)->getTempsMoyen();
}

int GestionEtape::getTempsMaxEtape(int indice)
{
    return getEtape(indice)->getTempsMax();
}

int GestionEtape::getDateMaxEtape(int indice)
{
    return getEtape(indice)->getDateMax();
}

int GestionEtape::getDeadLineEtape(int indice)
{
    return getEtape(indice)->getDeadline();
}

QString GestionEtape::getColorEtape(int indice)
{
    return getEtape(indice)->getColor();
}

QString GestionEtape::getNomSequenceEtape(int indice)
{
    return getEtape(indice)->getNameSequence();
}

int GestionEtape::getIndiceEtape(Etape * etape)
{
    return listEtape.indexOf(etape);
}

int GestionEtape::getNbEtape()
{
    return listEtape.size();
}

void GestionEtape::createNewEtape()
{
    listEtape.append(new Etape);
    listEtape.last()->setNomEtape("NewEtape");
}

void GestionEtape::toPrint()
{
    for(int i=0; i < getNbEtape() ; i++)
    {
        qDebug()<<"Etape : "<<i<<" Nom : "<<getEtape(i)->getNomEtape();
    }
}

void GestionEtape::updateEtape()
{
    QDir dir("data/Etape");
    QStringList filters;
    filters << "*.json";
    dir.setNameFilters(filters);
    QFileInfoList list = dir.entryInfoList();
    listEtape.clear();
    for (int i = 0 ; i < list.size() ; i++)
    {
        Etape * step = new Etape;
        step->setNomEtape(list.at(i).fileName().left(list.at(i).fileName().size()-5));
        QFile loadFile("data/Etape/"+list.at(i).fileName());
        if(!loadFile.open(QIODevice::ReadOnly))
        {
            qDebug()<<"Failed ! updateEtape";
        }else
        {
            QByteArray saveData = loadFile.readAll();
            QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));
            QJsonObject json = loadDoc.object();
            if (json.contains("Etape") )
            {
                if(json["Etape"].isObject())
                {
                    step->loadObject(json["Etape"].toObject());
                }
            }
        }
        addEtape(step);
    }
    emit stepUpdated();
}
