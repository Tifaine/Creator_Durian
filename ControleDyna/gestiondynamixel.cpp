#include "gestiondynamixel.h"
#include <QDebug>

GestionDynamixel::GestionDynamixel(mqttClient *client, QObject *parent) :
    QObject(parent),
    m_clientMqtt(client)
{
    m_clientMqtt->sub_topic("listDyna");
    m_clientMqtt->sub_topic("robot2ordi/getValueDyna");

    connect(m_clientMqtt, SIGNAL(listDyna(QString)), this, SLOT(listDynaMqtt(QString)));
    connect(m_clientMqtt, SIGNAL(valueDyna(QString)), this, SLOT(infoDynaMqtt(QString)));
}

void GestionDynamixel::addDyna(Dyna * dyna)
{
    listDyna.append( dyna );
    getValue( dyna );
}

void GestionDynamixel::publishGetListDyna()
{
    m_clientMqtt->pub_message("ordi2robot", "getListDyna");
}

void GestionDynamixel::listDynaMqtt(QString mlistDyna)
{
    listDyna.clear();
    mlistDyna = mlistDyna.left( mlistDyna.size() - 1 );
    QStringList list = mlistDyna.split(',');
    for(int i = 0; i < list.size(); i++)
    {
        emit ajoutDyna(list.at(i).toInt());
    }
}

void GestionDynamixel::getValue(Dyna * dyna)
{
    m_clientMqtt->pub_message("getValueDyna", QString::number(dyna->getId()));
}

void GestionDynamixel::setValue(Dyna * dyna)
{
    QString toSend;
    toSend.append(QString::number(dyna->getId()));
    toSend.append(",");
    toSend.append(QString::number(dyna->getValue()));
    toSend.append(",");
    toSend.append(QString::number(dyna->getVitesse()));
    m_clientMqtt->pub_message("setValueDyna", toSend);
}

void GestionDynamixel::infoDynaMqtt(QString infoDyna)
{
    qDebug()<<infoDyna;
    QStringList list = infoDyna.split(',');
    for(int i = 0; i < list.size(); i++)
    {
        if(listDyna.at(i)->getId() == list.at(0).toInt())
        {
            listDyna.at(i)->setValue( list.at(1).toInt() );
            listDyna.at(i)->setVitesse( list.at(2).toInt() );
        }
    }
}
