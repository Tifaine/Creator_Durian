#ifndef THREADMQTT_H
#define THREADMQTT_H

#include <QThread>
#include <QTimer>
#include "clientmqtt.h"

class ThreadMQTT: public QThread
{
    Q_OBJECT
public:
    ThreadMQTT(const char *id, const char *host, int port);
    void run() override;

    void publishMessage(QString topic, QString message);
    void subscribeTo(QString topic);

public slots:
    void onMessageFromMQTT(QString, QString);

signals:
    void onConnect();
    void vitesseGChanged(int);
    void vitesseDChanged(int);
    void codeurGChanged(int);
    void codeurDChanged(int);


private slots:
    void updatePublish();

private:
    QTimer *timer;
    clientMQTT *cli;
    const char *mId;
    const char *mHost;
    int mPort;
};

#endif // THREADMQTT_H
