#ifndef GESTIONDYNAMIXEL_H
#define GESTIONDYNAMIXEL_H

#include <QObject>
#include <QList>
#include <QMap>
#include "dyna.h"
#include "../mqttclient.h"

class GestionDynamixel : public QObject
{
    Q_OBJECT
public:
    explicit GestionDynamixel(mqttClient* client, QObject *parent = nullptr);

public slots:
    void addDyna(Dyna * dyna);
    void getValue(Dyna * dyna);
    void setValue(Dyna * dyna);
    void publishGetListDyna();

private slots:
    void listDynaMqtt(QString);
    void infoDynaMqtt(QString);

signals:
    void ajoutDyna(int id);

private:
    mqttClient *m_clientMqtt;
    QList < Dyna * > listDyna;

};

#endif // GESTIONDYNAMIXEL_H
