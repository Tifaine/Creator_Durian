#include "gestiondynamixel.h"
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QDir>

GestionDynamixel::GestionDynamixel(QObject *parent) : QObject(parent)
{

}

int GestionDynamixel::getNbDyna()
{
    return listDyna.count();
}

int GestionDynamixel::getIdDyna(int indice)
{
    return listDyna.at(indice)->id;
}

int GestionDynamixel::getValueDyna(int indice)
{
    return listDyna.at(indice)->value;
}

int GestionDynamixel::getSpeedDyna(int indice)
{
    return listDyna.at(indice)->speed;
}

QString GestionDynamixel::getNameDyna(int indice)
{
    return listDyna.at(indice)->name;
}

void GestionDynamixel::setValueDyna(int indice, int value)
{
    if( indice < listDyna.size())
    {
        listDyna.at(indice)->value = value;
    }
}


void GestionDynamixel::setVitesseDyna(int indice, int value)
{
    if( indice < listDyna.size())
    {
        listDyna.at(indice)->speed = value;
    }
}

void GestionDynamixel::saveDyna(int indice)
{
    QFile saveFile("data/Dyna/"+ listDyna.at(indice)->name +".json");
    if(!saveFile.open(QIODevice::ReadWrite))
    {
        qDebug()<<"Failed !";
    }else
    {
        saveFile.resize(0);
        saveFile.flush();
        QJsonObject saveObject;
        saveObject["nomDyna"] = listDyna.at(indice)->name;
        saveObject["id"] = listDyna.at(indice)->id;
        QJsonObject dynaObject;
        dynaObject["Dyna"] = saveObject;
        QJsonDocument saveDoc(dynaObject);
        saveFile.write(saveDoc.toJson());
    }
    saveFile.close();
}

void GestionDynamixel::updateListDyna()
{
    listDyna.clear();
    mapDyna.clear();
    QDir dir("data/Dyna");
    QStringList filters;
    filters << "*.json";
    dir.setNameFilters(filters);
    QFileInfoList list = dir.entryInfoList();


    for (int i = 0 ; i < list.size() ; i++)
    {
        QFile loadFile("data/Dyna/"+list.at(i).fileName());
        if(!loadFile.open(QIODevice::ReadOnly))
        {
            qDebug()<<"Failed !";
        }else
        {
            QByteArray saveData = loadFile.readAll();
            QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));
            QJsonObject json = loadDoc.object();
            if (json.contains("Dyna") )
            {
                if(json["Dyna"].isObject())
                {
                    QJsonObject dynaObject = json["Dyna"].toObject();

                    mapDyna[dynaObject["id"].toInt()] = dynaObject["nomDyna"].toString();

                    listDyna.append(new dyna);
                    listDyna.last()->id = dynaObject["id"].toInt();
                    listDyna.last()->name = dynaObject["nomDyna"].toString();
                    listDyna.last()->value = 0;
                    listDyna.last()->speed = 0;
                }
            }
        }
    }
    emit listDynaUpdated();
}

void GestionDynamixel::init()
{
    updateListDyna();
}
