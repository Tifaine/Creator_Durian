#ifndef CLIENTMQTT_H
#define CLIENTMQTT_H

#include <mosquittopp.h>
#include <QObject>

class clientMQTT : public QObject, public mosqpp::mosquittopp
{
    Q_OBJECT
public:
    clientMQTT(const char *id, const char *host, int port);

    void on_connect(int rc) override;
    void on_subscribe(int mid, int qos_count, const int *granted_qos) override;
    void on_message(const struct mosquitto_message *message) override;

    void publishMessage(QString topic, QString message);
    void subscribeTo(QString topic);

    void start();

signals:
    void isConnected();
    void onMessage(QString topic, QString payload);

};

#endif // CLIENTMQTT_H
