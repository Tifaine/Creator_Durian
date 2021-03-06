#include "editableaction.h"

EditableAction::EditableAction()
{

}

void EditableAction::open1(QJsonObject json)
{
    if(json.contains("nomAction") )
    {
        setNomAction(json["nomAction"].toString());
    }
    if(json.contains("xBloc") )
    {
        setXBloc(json["xBloc"].toInt());
    }
    if(json.contains("yBloc") )
    {
        setYBloc(json["yBloc"].toInt());
    }
    if(json.contains("blocante") )
    {
        setIsActionBlocante(json["blocante"].toBool());
    }
    if(json.contains("arrayParam") )
    {
        QJsonArray array = json["arrayParam"].toArray();
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
        }
    }
}

void EditableAction::open2(QJsonObject json)
{
    if(json.contains("arrayGirl") )
    {
        QJsonArray array = json["arrayGirl"].toArray();
        foreach (const QJsonValue & v, array)
        {
            QJsonObject obj = v.toObject();
            if(obj.contains("indiceFille") )
            {
                listIndiceFille.append(obj["indiceFille"].toInt());
            }
        }
    }
    if(json.contains("arrayTimeout") )
    {
        QJsonArray array = json["arrayTimeout"].toArray();
        foreach (const QJsonValue & v, array)
        {
            QJsonObject obj = v.toObject();
            if(obj.contains("indiceTimeout") )
            {
                listIndiceTimeout.append(obj["indiceTimeout"].toInt());
            }
        }
    }
}

void EditableAction::daughterIsMoving(EditableAction * act)
{
    if(listFille.contains(act))
    {
        listConnectorPere.at(listFille.indexOf(act)+1)->setX2(act->getXBloc() + act->getXEntree() - (getXBloc() + getXFather() - 10));
        listConnectorPere.at(listFille.indexOf(act)+1)->setY2(act->getYBloc() + act->getYEntree() - (getYBloc() + getYFather() - 10));
    }
    if(listTimeOut.contains(act))
    {
        listConnectorTimeout.at(listTimeOut.indexOf(act)+1)->setX2(act->getXBloc() + act->getXEntree() - (getXBloc() + getXTimeOut() - 10));
        listConnectorTimeout.at(listTimeOut.indexOf(act)+1)->setY2(act->getYBloc() + act->getYEntree() - (getYBloc() + getYTimeOut() - 10));
    }
}

QJsonObject EditableAction::saveAction()
{
    QJsonObject saveObject;
    saveObject["nomAction"] = nomAction;
    saveObject["blocante"] = isActionBlocante;


    QJsonArray arrayParam;
    QString nomParam("nomParam");
    QString value("value");
    for(auto item : listParam)
    {
        QJsonObject item_data;
        item_data.insert(nomParam, QJsonValue(item->nomParam));
        item_data.insert(value, QJsonValue(item->valueParam));
        arrayParam.push_back(QJsonValue(item_data));
    }

    saveObject["paramArray"] = arrayParam;
    return saveObject;
}

int EditableAction::getNbPapa()
{
    return listPere.count();
}

void EditableAction::clearListFille()
{
        listFille.clear();
}

QString EditableAction::getNomPapa(int indice)
{
    return listPere.at(indice)->nomAction;
}

int EditableAction::getXBloc() const
{
    return xBloc;
}

void EditableAction::setXBloc(int value)
{
    xBloc = value;
    for(int i = 0; i < listFille.size(); i++)
    {
        listConnectorPere.at(i+1)->setX2(listFille.at(i)->getXBloc() + listFille.at(i)->getXEntree() - (getXBloc() + getXFather() - 10));
        listConnectorPere.at(i+1)->setY2(listFille.at(i)->getYBloc() + listFille.at(i)->getYEntree() - (getYBloc() + getYFather() - 10));
    }

    for(int i = 0; i < listTimeOut.size(); i++)
    {
        listConnectorTimeout.at(i+1)->setX2(listTimeOut.at(i)->getXBloc() + listTimeOut.at(i)->getXEntree() - (getXBloc() + getXTimeOut() - 10));
        listConnectorTimeout.at(i+1)->setY2(listTimeOut.at(i)->getYBloc() + listTimeOut.at(i)->getYEntree() - (getYBloc() + getYTimeOut()));
    }

    for (int i = 0; i < listPere.size(); i++)
    {
        listPere.at(i)->daughterIsMoving(this);
    }
}

int EditableAction::getYBloc() const
{
    return yBloc;
}

void EditableAction::setYBloc(int value)
{
    yBloc = value;
    for(int i = 0; i < listFille.size(); i++)
    {
        listConnectorPere.at(i+1)->setX2(listFille.at(i)->getXBloc() + listFille.at(i)->getXEntree() - (getXBloc() + getXFather() - 10));
        listConnectorPere.at(i+1)->setY2(listFille.at(i)->getYBloc() + listFille.at(i)->getYEntree() - (getYBloc() + getYFather() - 10));
    }
    for(int i = 0; i < listTimeOut.size(); i++)
    {
        listConnectorTimeout.at(i+1)->setX2(listTimeOut.at(i)->getXBloc() + listTimeOut.at(i)->getXEntree() - (getXBloc() + getXTimeOut() - 10));
        listConnectorTimeout.at(i+1)->setY2(listTimeOut.at(i)->getYBloc() + listTimeOut.at(i)->getYEntree() - (getYBloc() + getYTimeOut()));
    }
    for (int i = 0; i < listPere.size(); i++)
    {
        listPere.at(i)->daughterIsMoving(this);
    }
}


void EditableAction::init(Action* parent)
{
    nomAction = parent->getNomAction();
    isActionBlocante = parent->getIsActionBlocante();
    for(int i=0; i<parent->getNbParam();i++)
    {
        addParam();
        setNomParam(i, parent->getNomParam(i));
        setValueDefaultParam(i, parent->getValueDefaultParam(i));
        for(int j=0; j<parent->getnbAlias(i); j++)
        {
            addAlias(i);
            setNomAlias(i, j, parent->getNomAlias(i, j));
            setValueAlias(i, j, parent->getValueAlias(i ,j));
        }
    }
}

void EditableAction::addConnectorToFather(Connector * con)
{
    listConnectorPere.insert(0, con);
}

void EditableAction::addConnectorToTimeOut(Connector * con)
{
    listConnectorTimeout.insert(0, con);
}

bool EditableAction::addGirlToFather(EditableAction* fille)
{
    if(!(listFille.contains(fille)))
    {
        listFille.insert(0, fille);
        moveConnectorFather(fille->getXBloc() + fille->getXEntree() - (getXBloc() + getXFather() - 10),
                            fille->getYBloc() + fille->getYEntree() - (getYBloc() + getYFather() - 10));
        return true;
    }else
    {
        moveConnectorFather(0, 0);
    }
    return false;
}

bool EditableAction::addGirlToTimeout(EditableAction * fille)
{
    if(!(listTimeOut.contains(fille)))
    {
        listTimeOut.insert(0, fille);
        moveConnectorTimeout(fille->getXBloc() + fille->getXEntree() - (getXBloc() + getXTimeOut() - 10),
                             fille->getYBloc() + fille->getYEntree() - (getYBloc() + getYTimeOut() - 10));
        return true;
    }else
    {
        moveConnectorTimeout(0, 0);
    }
    return false;
}

void EditableAction::addFatherToGirl(EditableAction * pere)
{
    listPere.append(pere);
}

bool EditableAction::addGirlToFatherForExport(EditableAction* fille)
{
    if(!(listFille.contains(fille)))
    {
        listFille.insert(0, fille);
        return true;
    }
    return false;
}

bool EditableAction::addGirlToTimeoutForExport(EditableAction * fille)
{
    if(!(listTimeOut.contains(fille)))
    {
        listTimeOut.insert(0, fille);
        return true;
    }
    return false;
}

void EditableAction::moveConnectorFather(int x, int y)
{
    listConnectorPere.first()->setX2(x);
    listConnectorPere.first()->setY2(y);
}

void EditableAction::moveConnectorTimeout(int x, int y)
{
    listConnectorTimeout.first()->setX2(x);
    listConnectorTimeout.first()->setY2(y);
}

int EditableAction::getYEntree() const
{
    return yEntree;
}

void EditableAction::setYEntree(int value)
{
    yEntree = value;
}

QList<EditableAction *> EditableAction::getListTimeOut() const
{
    return listTimeOut;
}

QList<EditableAction *> EditableAction::getListFille() const
{
    return listFille;
}

QList<EditableAction *> EditableAction::getListPere() const
{
    return listPere;
}

int EditableAction::getNbfille()
{
    return listIndiceFille.size();
}

int EditableAction::getNbTimeout()
{
    return listIndiceTimeout.size();
}

int EditableAction::getIndicefille(int indice)
{
    return listIndiceFille.at(indice);
}

int EditableAction::getIndiceTimeout(int indice)
{
    return listIndiceTimeout.at(indice);
}

void EditableAction::abandonnerFille(EditableAction * act)
{
    if(listFille.contains(act))
    {
        listFille.removeOne(act);
        emit eraseAFather();
    }

    if(listTimeOut.contains(act))
    {
        listTimeOut.removeOne(act);
        emit eraseATimeout();
    }

    for(int i = 0; i < listFille.size(); i++)
    {
        listConnectorPere.at(i+1)->setX2(listFille.at(i)->getXBloc() + listFille.at(i)->getXEntree() - (getXBloc() + getXFather() - 10));
        listConnectorPere.at(i+1)->setY2(listFille.at(i)->getYBloc() + listFille.at(i)->getYEntree() - (getYBloc() + getYFather() - 10));
    }
    for(int i = 0; i < listTimeOut.size(); i++)
    {
        listConnectorTimeout.at(i+1)->setX2(listTimeOut.at(i)->getXBloc() + listTimeOut.at(i)->getXEntree() - (getXBloc() + getXTimeOut() - 10));
        listConnectorTimeout.at(i+1)->setY2(listTimeOut.at(i)->getYBloc() + listTimeOut.at(i)->getYEntree() - (getYBloc() + getYTimeOut()));
    }

}

void EditableAction::prepareToErase()
{
    for(int i = 0; i < listFille.size(); i++)
    {
        listFille.at(i)->abandonnerPere(this);
    }
    for(int i = 0 ; i < listPere.size(); i++)
    {
        listPere.at(i)->abandonnerFille(this);
    }
    for(int i = 0 ; i < listTimeOut.size(); i++)
    {
        listTimeOut.at(i)->abandonnerFille(this);
    }

}

void EditableAction::abandonnerPere(EditableAction * act)
{
    listPere.removeOne(act);
}

void EditableAction::abandonnerPere(int indice)
{
    listPere.at(indice)->abandonnerFille(this);
    listPere.removeAt(indice);
}

int EditableAction::getXEntree() const
{
    return xEntree;
}

void EditableAction::setXEntree(int value)
{
    xEntree = value;
}

int EditableAction::getYTimeOut() const
{
    return yTimeOut;
}

void EditableAction::setYTimeOut(int value)
{
    yTimeOut = value;
}

int EditableAction::getXTimeOut() const
{
    return xTimeOut;
}

void EditableAction::setXTimeOut(int value)
{
    xTimeOut = value;
}

int EditableAction::getYFather() const
{
    return yFather;
}

void EditableAction::setYFather(int value)
{
    yFather = value;
}

int EditableAction::getXFather() const
{
    return xFather;
}

void EditableAction::setXFather(int value)
{
    xFather = value;
}
