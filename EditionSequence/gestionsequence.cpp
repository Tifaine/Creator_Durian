#include "gestionsequence.h"

GestionSequence::GestionSequence()
{

}

void GestionSequence::addAction( EditableAction * act)
{
    listAction.append(act);
}

void GestionSequence::save(QString nomFile)
{
    QFile saveFile("data/Sequence/"+ nomFile +".json");
    if(!saveFile.open(QIODevice::ReadWrite))
    {
        qDebug()<<"Failed !";
    }else
    {
        saveFile.flush();
        QJsonObject saveObject;
        QJsonArray arraySequence;
        for(auto item : listAction)
        {
            QJsonObject saveObject;


            QJsonArray arrayParam;
            QString nomParam("nomParam");
            QString defaultValue("defaultValue");
            for(int i = 0; i < item->getNbParam(); i++)
            {
                QJsonObject item_data;
                item_data.insert(nomParam, QJsonValue(item->getNomParam(i)));
                item_data.insert(defaultValue, QJsonValue(item->getValueDefaultParam(i)));
                arrayParam.push_back(QJsonValue(item_data));
            }

            QJsonArray arrayPere;
            QString indicePere("indicePere");
            for(int i = 0; i < item->getListPere().size(); i++)
            {
                QJsonObject item_daddy;
                item_daddy.insert(indicePere, listAction.indexOf(item->getListPere().at(i)));
                arrayPere.push_back(QJsonValue(item_daddy));
            }

            QJsonArray arrayFille;
            QString indiceFille("indiceFille");
            for(int i = 0; i < item->getListFille().size(); i++)
            {
                QJsonObject item_girl;
                item_girl.insert(indiceFille, listAction.indexOf(item->getListFille().at(i)));
                arrayFille.push_back(QJsonValue(item_girl));
            }

            QJsonArray arrayTimeout;
            QString indiceTimeout("indiceTimeout");
            for(int i = 0; i < item->getListTimeOut().size(); i++)
            {
                QJsonObject item_timeout;
                item_timeout.insert(indiceTimeout, listAction.indexOf(item->getListTimeOut().at(i)));
                arrayTimeout.push_back(QJsonValue(item_timeout));
            }
            saveObject["arrayDaddy"] = arrayPere;
            saveObject["arrayGirl"] = arrayFille;
            saveObject["arrayTimeout"] = arrayTimeout;
            saveObject["arrayParam"] = arrayParam;
            saveObject["blocante"] = item->getIsActionBlocante();
            saveObject["indice"] = listAction.indexOf(item);
            saveObject["nomAction"] = item->getNomAction();
            arraySequence.push_back(QJsonValue(saveObject));
        }
        saveObject["sequence"] = arraySequence;
        QJsonDocument saveDoc(saveObject);
        saveFile.write(saveDoc.toJson());
        saveFile.close();
    }
}

void GestionSequence::open(QString nomFile)
{
    qDebug()<<nomFile;
}

void GestionSequence::clearAction()
{
    listAction.clear();
}