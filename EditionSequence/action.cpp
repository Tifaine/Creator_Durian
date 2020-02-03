#include "action.h"

Action::Action() :
    isActionBlocante(false)
{

}

QString Action::getNomAction() const
{
    return nomAction;
}

void Action::setNomAction(const QString &value)
{
    nomAction = value;
}

bool Action::getIsActionBlocante() const
{
    return isActionBlocante;
}

void Action::setIsActionBlocante(bool value)
{
    isActionBlocante = value;
}

void Action::addParam()
{
    listParam.append(new param);
}

int Action::getNbParam()
{
    return listParam.size();
}

param* Action::getParam(int indice)
{
    return listParam.at(indice);
}

void Action::setNomParam(int indiceParam, QString nomParam)
{
    listParam.at(indiceParam)->nomParam = nomParam;
}

QString Action::getNomParam(int indiceParam)
{
    return listParam.at(indiceParam)->nomParam;
}

void Action::setValueDefaultParam(int indiceParam, QString valueDefault)
{
    listParam.at(indiceParam)->valueParam = valueDefault;
}

QString Action::getValueDefaultParam(int indiceParam)
{
    return listParam.at(indiceParam)->valueParam;
}

void Action::addAlias(int indiceParam)
{
    listParam.at(indiceParam)->listAlias.append(new alias);
}

int Action::getnbAlias(int indiceParam)
{
    return listParam.at(indiceParam)->listAlias.size();
}

alias* Action::getAlias(int indiceParam, int indiceAlias)
{
    return listParam.at(indiceParam)->listAlias.at(indiceAlias);
}

void Action::setNomAlias(int indiceParam, int indiceAlias, QString nom)
{
    listParam.at(indiceParam)->listAlias.at(indiceAlias)->nomAlias = nom;
}

QString Action::getNomAlias(int indiceParam, int indiceAlias)
{
    return listParam.at(indiceParam)->listAlias.at(indiceAlias)->nomAlias;
}

void Action::setValueAlias(int indiceParam, int indiceAlias, QString value)
{
    listParam.at(indiceParam)->listAlias.at(indiceAlias)->valueAlias = value;
}

QString Action::getValueAlias(int indiceParam, int indiceAlias)
{
    return listParam.at(indiceParam)->listAlias.at(indiceAlias)->valueAlias;
}

void Action::save()
{
    QFile saveFile("data/Sequence/Action/"+ getNomAction() +".json");
    if(!saveFile.open(QIODevice::ReadWrite))
    {
        qDebug()<<"Failed !";
    }else
    {
        saveFile.flush();

        QJsonObject saveObject = saveAction();
        QJsonObject etapeObject;
        etapeObject["Action"] = saveObject;
        QJsonDocument saveDoc(etapeObject);
        saveFile.write(saveDoc.toJson());
    }

    saveFile.close();
}

QJsonObject Action::saveAction()
{
    QJsonObject saveObject;
    saveObject["nomAction"] = nomAction;
    saveObject["blocante"] = isActionBlocante;

    QJsonArray arrayParam;
    QString nomParam("nomParam");
    QString defaultValue("defaultValue");
    for(auto item : listParam)
    {
        QJsonObject item_data;
        item_data.insert(nomParam, QJsonValue(item->nomParam));
        item_data.insert(defaultValue, QJsonValue(item->valueParam));

        QJsonArray arrayAlias;
        QString nomAlias("nomAlias");
        QString valueAlias("valueAlias");
        QString aliasArray("aliasArray");
        for(auto itemAlias : item->listAlias)
        {
            QJsonObject item_Alias;
            item_Alias.insert(nomAlias, QJsonValue(itemAlias->nomAlias));
            item_Alias.insert(valueAlias, QJsonValue(itemAlias->valueAlias));

            arrayAlias.push_back(QJsonValue(item_Alias));
        }
        item_data.insert(aliasArray, QJsonValue(arrayAlias));

        arrayParam.push_back(QJsonValue(item_data));
    }

    saveObject["paramArray"] = arrayParam;
    return saveObject;
}

void Action::loadAction(QJsonObject json)
{
    if(json.contains("nomAction") )
    {
        setNomAction(json["nomAction"].toString());
    }
    if(json.contains("blocante") )
    {
        setIsActionBlocante(json["blocante"].toBool());
    }
    if(json.contains("paramArray") )
    {
        QJsonArray array = json["paramArray"].toArray();
        foreach (const QJsonValue & v, array)
        {
            addParam();
            QJsonObject obj = v.toObject();
            if(obj.contains("nomParam") )
            {
                setNomParam(getNbParam()-1, obj["nomParam"].toString());
            }
            if(obj.contains("defaultValue") )
            {
                setValueDefaultParam(getNbParam()-1, obj["defaultValue"].toString());
            }
            if(obj.contains("aliasArray") )
            {
                QJsonArray arrayAlias = obj["aliasArray"].toArray();
                foreach (const QJsonValue & w, arrayAlias)
                {
                    addAlias(getNbParam()-1);
                    QJsonObject objAlias = w.toObject();
                    setNomAlias(getNbParam()-1, getnbAlias(getNbParam()-1)-1, objAlias.value("nomAlias").toString());
                    setValueAlias(getNbParam()-1, getnbAlias(getNbParam()-1)-1, objAlias.value("valueAlias").toString());
                }
            }
        }
    }
}


void Action::clearAlias(int indiceParam)
{
        listParam.at(indiceParam)->listAlias.clear();
}
