#include "gestiondynamixel.h"
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

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
    QFile saveFile("data/Etape/"+ listDyna.at(indice)->name +".json");
    if(!saveFile.open(QIODevice::ReadWrite))
    {
        qDebug()<<"Failed !";
    }else
    {
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
    listDyna.append(new dyna);
    listDyna.last()->id = 10;
    listDyna.last()->name = "TestDyna";
    listDyna.last()->value = 0;
    listDyna.last()->speed = 0;

    listDyna.append(new dyna);
    listDyna.last()->id = 12;
    listDyna.last()->name = "FooDyna";
    listDyna.last()->value = 0;
    listDyna.last()->speed = 0;
    emit listDynaUpdated();
}

void GestionDynamixel::init()
{
    updateListDyna();
}
