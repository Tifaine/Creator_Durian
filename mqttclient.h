#ifndef MQTTCLIENT_H
#define MQTTCLIENT_H

#include <QObject>
#include <QList>
#include <QtMqtt/QMqttClient>
#include <QtMqtt/QMqttMessage>
#include <QtMqtt/QMqttSubscription>

class mqttClient : public QObject
{
    Q_OBJECT
public:
    explicit mqttClient(QObject *parent = nullptr);
    void pub_message(QString topic, QString payload);
    void sub_topic(QString topic);


private slots:
    void updateMessage(const QMqttMessage &msg);
    void updateStatus(QMqttSubscription::SubscriptionState state);
    void updateLogStateChange();

signals:
    void listDyna(QString listDyna);
    void valueDyna(QString value);
private:
    QMqttClient* m_client;
    QList< QString > listEnAttente;
    QList<QMqttSubscription *> listSub;

};

#endif // MQTTCLIENT_H
