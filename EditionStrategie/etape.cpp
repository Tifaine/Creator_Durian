#include "etape.h"
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

Etape::Etape() :
    nbPoints(0),
    tempsMoyen(0),
    tempsMax(0),
    dateMax(0),
    deadline(0)
{

}

QString Etape::getNomEtape() const
{
    return nomEtape;
}

void Etape::setNomEtape(const QString &value)
{
    nomEtape = value;
}

int Etape::getTempsMax() const
{
    return tempsMax;
}

void Etape::setTempsMax(int value)
{
    tempsMax = value;
}

int Etape::getDateMax() const
{
    return dateMax;
}

void Etape::setDateMax(int value)
{
    dateMax = value;
}

int Etape::getDeadline() const
{
    return deadline;
}

void Etape::setDeadline(int value)
{
    deadline = value;
}

int Etape::getTempsMoyen() const
{
    return tempsMoyen;
}

void Etape::setTempsMoyen(int value)
{
    tempsMoyen = value;
}

int Etape::getNbPoints() const
{
    return nbPoints;
}

void Etape::setNbPoints(int value)
{
    nbPoints = value;
}

void Etape::addItemTaux()
{
    listTaux.append(new ItemTaux);
}

void Etape::setParamTaux(int indice, int value)
{
   listTaux.at(indice)->setParam(value);
}

int Etape::getParamTaux(int indice)
{
    return listTaux.at(indice)->getParam();
}

void Etape::setCondTaux(int indice, int value)
{
    listTaux.at(indice)->setCondition(value);
}

int Etape::getCondTaux(int indice)
{
    return listTaux.at(indice)->getCondition();
}

void Etape::setValueTaux(int indice, int value)
{
    listTaux.at(indice)->setValeur(value);
}

int Etape::getValueTaux(int indice)
{
    return listTaux.at(indice)->getValeur();
}

void Etape::setRatioTaux(int indice, int value)
{
    listTaux.at(indice)->setTaux(value);
}

int Etape::getRatioTaux(int indice)
{
    return listTaux.at(indice)->getTaux();
}

int Etape::getNbTaux()
{
    return listTaux.size();
}

void Etape::save()
{
    QFile saveFile("data/Etape/"+ getNomEtape() +".json");
    if(!saveFile.open(QIODevice::ReadWrite))
    {
        qDebug()<<"Failed !";
    }else
    {
        saveFile.flush();
        QJsonObject saveObject;
        saveObject["nomEtape"] = nomEtape;
        saveObject["nbPoints"] = nbPoints;
        saveObject["tempsMoyen"] = tempsMoyen;
        saveObject["tempsMax"] = tempsMax;
        saveObject["dateMax"] = dateMax;
        saveObject["deadline"] = deadline;

        QJsonArray array_Taux;
        QString param("param");
        QString condition("condition");
        QString valeur("valeur");
        QString taux("taux");
        for(auto item : listTaux)
        {
            QJsonObject item_data;
            item_data.insert(param, QJsonValue(item->getParam()));
            item_data.insert(condition, QJsonValue(item->getCondition()));
            item_data.insert(valeur, QJsonValue(item->getValeur()));
            item_data.insert(taux, QJsonValue(item->getTaux()));

            array_Taux.push_back(QJsonValue(item_data));
        }

        saveObject["TauxArray"] = array_Taux;

        QJsonObject etapeObject;
        etapeObject["Etape"] = saveObject;
        QJsonDocument saveDoc(etapeObject);
        saveFile.write(saveDoc.toJson());
    }

    saveFile.close();
}
