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

int GestionEtape::getIndiceEtape(Etape * etape)
{
    return listEtape.indexOf(etape);
}

int GestionEtape::getNbEtape()
{
    return listEtape.size();
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
            qDebug()<<"Failed !";
        }else
        {
            QByteArray saveData = loadFile.readAll();
            QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));
            QJsonObject json = loadDoc.object();
            if (json.contains("Etape") )
            {
                if(json["Etape"].isObject())
                {
                    QJsonObject etape = json["Etape"].toObject();
                    if(etape.contains("nbPoints") )
                    {
                        step->setNbPoints(etape["nbPoints"].toInt());
                    }
                    if(etape.contains("tempsMoyen") )
                    {
                        step->setTempsMoyen(etape["tempsMoyen"].toInt());
                    }
                    if(etape.contains("tempsMax") )
                    {
                        step->setTempsMax(etape["tempsMax"].toInt());
                    }
                    if(etape.contains("dateMax") )
                    {
                        step->setDateMax(etape["dateMax"].toInt());
                    }
                    if(etape.contains("deadline") )
                    {
                        step->setDeadline(etape["deadline"].toInt());
                    }
                    if(etape.contains("TauxArray") )
                    {
                        QJsonArray array = etape["TauxArray"].toArray();
                        foreach (const QJsonValue & v, array)
                        {
                            step->addItemTaux();
                            QJsonObject obj = v.toObject();
                            step->setCondTaux(step->getNbTaux()-1, obj.value("condition").toInt());
                            step->setParamTaux(step->getNbTaux()-1, obj.value("param").toInt());
                            step->setRatioTaux(step->getNbTaux()-1, obj.value("taux").toInt());
                            step->setValueTaux(step->getNbTaux()-1, obj.value("valeur").toInt());

                        }
                    }
                }
            }
        }
        addEtape(step);
    }
}
