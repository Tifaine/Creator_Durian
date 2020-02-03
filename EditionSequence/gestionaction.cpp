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
    for (int i = 0 ; i < list.size() ; i++)
    {
        Action * action = new Action;
        QFile loadFile("data/Sequence/Action/"+list.at(i).fileName());
        if(!loadFile.open(QIODevice::ReadOnly))
        {
            qDebug()<<"Failed !";
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
