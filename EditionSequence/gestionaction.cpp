#include "gestionaction.h"

GestionAction::GestionAction(QObject *parent) : QObject(parent)
{

}

void GestionAction::addAction(Action* action)
{
    listAction.append(action);
}

void GestionAction::updateAction()
{

    QDir dir("data/Sequence/Action");
    QStringList filters;
    filters << "*.json";
    dir.setNameFilters(filters);
    QFileInfoList list = dir.entryInfoList();
    listAction.clear();
    init();
    for (int i = 0 ; i < list.size() ; i++)
    {
        Action * action = new Action;
        QFile loadFile("data/Sequence/Action/"+list.at(i).fileName());
        if(!loadFile.open(QIODevice::ReadOnly))
        {
            qDebug()<<"Failed ! "<<loadFile.fileName();
        }else
        {
            QByteArray saveData = loadFile.readAll();
            QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));
            QJsonObject json = loadDoc.object();
            if (json.contains("Action") )
            {
                if(json["Action"].isObject())
                {
                    action->loadAction(json["Action"].toObject());
                    emit nouvelleAction(action->getNomAction(), action->getIsActionBlocante());
                    for (int i = 0; i < action->getNbParam(); i++)
                    {
                        emit addParam(action->getNomParam(i), action->getValueDefaultParam(i));
                        for (int j = 0; j < action->getnbAlias( i ); j++)
                        {
                            emit addAlias(i, j, action->getNomAlias(i, j), action->getValueAlias(i, j));
                        }
                    }
                }
            }
        }
    }
    emit actionsUpdated();
}

int GestionAction::getNbAction()
{
    return listAction.size();
}

QString GestionAction::getNameAction(int indice)
{
    return listAction.at(indice)->getNomAction();
}

int GestionAction::getNbParameter(int indiceAction)
{
    return listAction.at(indiceAction)->getNbParam();
}

QString GestionAction::getNomParam(int indiceAction, int indiceParam)
{
    return listAction.at(indiceAction)->getNomParam(indiceParam);
}

QString GestionAction::getDefaultValueParam(int indiceAction, int indiceParam)
{
    return listAction.at(indiceAction)->getValueDefaultParam(indiceParam);
}

int GestionAction::getIsActionBlocante(int indice)
{
    return listAction.at(indice)->getIsActionBlocante();
}

int GestionAction::getNbAlias(int indiceAction, int indiceParam)
{
    return listAction.at(indiceAction)->getnbAlias(indiceParam);
}

QString GestionAction::getNomAlias(int indiceAction, int indiceParam, int indiceAlias)
{
    return listAction.at(indiceAction)->getNomAlias(indiceParam, indiceAlias);
}

QString GestionAction::getValueAlias(int indiceAction, int indiceParam, int indiceAlias)
{
    return listAction.at(indiceAction)->getValueAlias(indiceParam, indiceAlias);
}

int GestionAction::getIndiceByName(QString name)
{
    for(int i = 0; i<listAction.size(); i++)
    {
        if(listAction.at(i)->getNomAction() == name)
        {
            return i;
        }
    }
    return -1;
}

Action* GestionAction::getAction(int indice)
{
    return listAction.at(indice);
}

void GestionAction::init()
{
    //Création des actions de base
    emit nouvelleAction("Départ", false);
    emit nouvelleAction("Fin", false);
    emit nouvelleAction("Sequence", false);
    emit addParam("Nom", "init");
}


