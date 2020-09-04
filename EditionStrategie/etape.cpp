#include "etape.h"
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include "position.h"

Etape::Etape() :
    nbPoints(0),
    tempsMoyen(0),
    tempsMax(0),
    dateMax(0),
    deadline(0),
    x(0),
    y(0),
    isDone(false)
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
        qDebug()<<"Failed ! "<<saveFile.fileName();
    }else
    {
        saveFile.flush();
        saveFile.resize(0);

        QJsonObject saveObject = saveEtape();
        QJsonObject etapeObject;
        etapeObject["Etape"] = saveObject;
        QJsonDocument saveDoc(etapeObject);
        saveFile.write(saveDoc.toJson());
    }

    saveFile.close();
}

bool Etape::containsPosition(Position* mPos)
{
    return listPositionsLiees.contains(mPos);
}

void Etape::addPositionLiee(Position* mPos)
{
    listPositionsLiees.append(mPos);
}

int Etape::getNbPositionLiee()
{
    return listPositionsLiees.count();
}

Position* Etape::getPosition(int _index)
{
    if (getNbPositionLiee() > _index)
    {
        return listPositionsLiees.at(_index);
    }
    return NULL;
}

bool Etape::getIsDone() const
{
    return isDone;
}

void Etape::setIsDone(bool value)
{
    isDone = value;
    if(value)
    {
        emit hide();
    }
}

QJsonObject Etape::saveEtape()
{
    QJsonObject saveObject;
    saveObject["nomEtape"] = nomEtape;
    saveObject["nbPoints"] = nbPoints;
    saveObject["tempsMoyen"] = tempsMoyen;
    saveObject["tempsMax"] = tempsMax;
    saveObject["dateMax"] = dateMax;
    saveObject["deadline"] = deadline;
    saveObject["color"] = color;
    qDebug()<<nameSequence;
    saveObject["sequenceName"] = nameSequence;
    saveObject["xEtape"] = x;
    saveObject["yEtape"] = y;

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
    return saveObject;
}

void Etape::loadObject(QJsonObject json)
{

    if(json.contains("nomEtape") )
    {
        setNomEtape(json["nomEtape"].toString());
    }
    if(json.contains("nbPoints") )
    {
        setNbPoints(json["nbPoints"].toInt());
    }
    if(json.contains("tempsMoyen") )
    {
        setTempsMoyen(json["tempsMoyen"].toInt());
    }
    if(json.contains("tempsMax") )
    {
        setTempsMax(json["tempsMax"].toInt());
    }
    if(json.contains("dateMax") )
    {
        setDateMax(json["dateMax"].toInt());
    }
    if(json.contains("deadline") )
    {
        setDeadline(json["deadline"].toInt());
    }
    if(json.contains("color") )
    {
        setColor(json["color"].toString());
    }
    if(json.contains("sequenceName") )
    {
        setNameSequence(json["sequenceName"].toString());
    }
    if(json.contains("xEtape") )
    {
        setX(json["xEtape"].toInt());
    }
    if(json.contains("yEtape") )
    {
        setY(json["yEtape"].toInt());
    }
    if(json.contains("TauxArray") )
    {
        QJsonArray array = json["TauxArray"].toArray();
        foreach (const QJsonValue & v, array)
        {
            addItemTaux();
            QJsonObject obj = v.toObject();
            setCondTaux(getNbTaux()-1, obj.value("condition").toInt());
            setParamTaux(getNbTaux()-1, obj.value("param").toInt());
            setRatioTaux(getNbTaux()-1, obj.value("taux").toInt());
            setValueTaux(getNbTaux()-1, obj.value("valeur").toInt());

        }
    }
}

QString Etape::getNameSequence() const
{
    return nameSequence;
}

void Etape::setNameSequence(const QString &value)
{
    nameSequence = value;
}

int Etape::getY() const
{
    return y;
}

void Etape::setY(int value)
{
    y = value;
    emit yModified();
}

int Etape::getX() const
{
    return x;
}

void Etape::setX(int value)
{
    x = value;
    emit xModified();
}

QString Etape::getColor() const
{
    return color;
}

void Etape::setColor(const QString &value)
{
    color = value;
}
