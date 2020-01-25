#include "threadmqtt.h"
#include <QDebug>

ThreadMQTT::ThreadMQTT(const char *id, const char *host, int port):
    mId(id),
    mHost(host),
    mPort(port)
{
   /* cli = new clientMQTT(mId, mHost, mPort);
    connect(cli, SIGNAL(isConnected()), this, SIGNAL(onConnect()));
    connect(cli, SIGNAL(onMessage(QString, QString)), this, SLOT(onMessageFromMQTT(QString, QString)));
    timer = new QTimer();
    connect(timer, &QTimer::timeout, this, QOverload<>::of(&ThreadMQTT::updatePublish));
    timer->start(20);*/
}

void ThreadMQTT::run()
{
   // cli->start();
}

void ThreadMQTT::publishMessage(QString topic, QString message)
{    
 //   cli->publishMessage(topic, message);
}

void ThreadMQTT::subscribeTo(QString topic)
{
  //  cli->subscribeTo( topic );
}

void ThreadMQTT::onMessageFromMQTT(QString topic, QString message)
{
    if(topic == "roboclaw/r2o/get/motor/m1/speed/value")
    {
        emit vitesseGChanged(message.toInt());
    }else if (topic == "roboclaw/r2o/get/motor/m2/speed/value")
    {
        emit vitesseDChanged(message.toInt());
    }else if(topic == "roboclaw/r2o/get/codeur/m1/value")
    {
        emit codeurGChanged(message.toInt());
    }else if(topic == "roboclaw/r2o/get/codeur/m2/value")
    {
        emit codeurDChanged(message.toInt());
    }
}

void ThreadMQTT::updatePublish()
{
    publishMessage("roboclaw/o2r/get/codeur/m1/value","boop");
    publishMessage("roboclaw/o2r/get/motor/m1/speed/value","boop");
    publishMessage("roboclaw/o2r/get/motor/m2/speed/value","boop");
}
