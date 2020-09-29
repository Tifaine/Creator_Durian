#include "mqttclient.h"
#include <QDebug>

mqttClient::mqttClient(QObject *parent) : QObject(parent)
{
#ifdef Q_OS_LINUX
    m_client = new QMqttClient(this);
    m_client->setHostname("127.0.0.1");
    m_client->setPort(1883);

    connect(m_client, &QMqttClient::stateChanged, this, &mqttClient::updateLogStateChange);

    m_client->connectToHost();
#endif

}

void mqttClient::pub_message(QString topic, QString payload)
{
#ifdef Q_OS_LINUX
    m_client->publish(topic, payload.toUtf8());
#endif
}

void mqttClient::sub_topic(QString topic)
{
#ifdef Q_OS_LINUX
    if( m_client->state() == QMqttClient::Connected)
    {
        connect(listSub.last(), &QMqttSubscription::messageReceived, this, &mqttClient::updateMessage);
    }else
    {
        listEnAttente.append(topic);
    }
#endif
}
#ifdef Q_OS_LINUX
void mqttClient::updateMessage(const QMqttMessage &msg)
{
    qDebug()<<msg.topic().name()<<" "<<msg.payload();
    if(msg.topic().name() == "listDyna")
    {
        emit listDyna( msg.payload());
    }else if(msg.topic().name() == "robot2ordi/getValueDyna")
    {
        emit valueDyna( msg.payload());
    }
}


void mqttClient::updateStatus(QMqttSubscription::SubscriptionState state)
{
    qDebug()<<state;
}

void mqttClient::updateLogStateChange()
{
    qDebug()<<"On est là "<<m_client->state();
    if( m_client->state() == QMqttClient::Connected)
    {
        for(int i = 0; i < listEnAttente.size();i++)
        {
            listSub.append(m_client->subscribe(QMqttTopicFilter(listEnAttente.at(i)), 1));
            connect(listSub.last(), &QMqttSubscription::messageReceived, this, &mqttClient::updateMessage);

        }
        listEnAttente.clear();
    }
}
#endif
