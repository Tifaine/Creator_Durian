#include "clientmqtt.h"
#include <QDebug>

clientMQTT::clientMQTT(const char *id, const char *host, int port) : mosquittopp(id)
{

    int keepalive = 60;
    mosqpp::lib_init();
    /* Connect immediately. This could also be done by calling
         * mqtt_tempconv->connect(). */
    mosquittopp::connect(host, port, keepalive);
}

void clientMQTT::start()
{
    qDebug()<<"La";
    this->loop_forever();
}

void clientMQTT::on_connect(int rc)
{
    qDebug()<<"Connected with code "<< rc;
    if(rc == 0){
        /* Only attempt to subscribe on a successful connect. */
        emit isConnected();
    }
}


void clientMQTT::on_subscribe(int mid, int qos_count, const int *granted_qos)
{

}

void clientMQTT::on_message(const struct mosquitto_message *message)
{
    emit onMessage(QString::fromLatin1(message->topic), QString::fromLatin1((char *)(message->payload)));
}

void clientMQTT::publishMessage(QString topic, QString message)
{
    this->publish(nullptr, topic.toStdString().c_str(), message.size()+1, message.toStdString().c_str(), 1);
}

void clientMQTT::subscribeTo(QString topic)
{

    this->subscribe(nullptr, topic.toStdString().c_str(), 1);
}
