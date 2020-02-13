#include "gestionroboclaw.h"

#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QRandomGenerator>
#include <QTextStream>
#include <QDebug>

GestionRoboclaw::GestionRoboclaw()
{
    isInit = false;
    consigneVD = 0;
    consigneVG = 0;
    accD = 0;
    accG = 0;
    threadMQTT = new ThreadMQTT("coucou", "192.168.0.28", 1883);

}

int GestionRoboclaw::getCodeurGauche() const
{
    return codeurGauche;
}

void GestionRoboclaw::setCodeurGauche(int value)
{
    codeurGauche = value;
    emit codeurGaucheChanged(codeurGauche);
}

int GestionRoboclaw::getCodeurDroit() const
{
    return codeurDroit;
}

void GestionRoboclaw::setCodeurDroit(int value)
{
    codeurDroit = value;
    emit codeurDroitChanged(codeurDroit);
}

int GestionRoboclaw::getVitesseGauche() const
{
    return vitesseGauche;
}

void GestionRoboclaw::setVitesseGauche(int value)
{
    vitesseGauche = value;
    emit vitesseGaucheChanged(vitesseGauche);
}

int GestionRoboclaw::getVitesseDroite() const
{
    return vitesseDroite;
}

void GestionRoboclaw::setVitesseDroite(int value)
{
    vitesseDroite = value;
    emit vitesseDroitChanged(vitesseDroite);
}

int GestionRoboclaw::getQPPSMaxG() const
{
    return QPPSMaxG;
}

void GestionRoboclaw::setQPPSMaxG(int value)
{
    QPPSMaxG = value;
    saveParam();
    QString toSend;
    toSend.append(QString::number(coeffPg));
    toSend.append("_");
    toSend.append(QString::number(coeffIg));
    toSend.append("_");
    toSend.append(QString::number(coeffDg));
    toSend.append("_");
    toSend.append(QString::number(QPPSMaxG));
    threadMQTT->publishMessage("roboclaw/o2r/set/motor/m1/qpps", toSend);

}

int GestionRoboclaw::getQPPSMaxD() const
{
    return QPPSMaxD;
}

void GestionRoboclaw::setQPPSMaxD(int value)
{
    QPPSMaxD = value;
    saveParam();
    QString toSend;
    toSend.append(QString::number(coeffPd));
    toSend.append("_");
    toSend.append(QString::number(coeffId));
    toSend.append("_");
    toSend.append(QString::number(coeffDd));
    toSend.append("_");
    toSend.append(QString::number(QPPSMaxD));
    threadMQTT->publishMessage("roboclaw/o2r/set/motor/m2/qpps", toSend);

}

int GestionRoboclaw::getConsigneVG() const
{
    return consigneVG;
}

void GestionRoboclaw::setConsigneVG(int value)
{
    consigneVG = value;
    QString toSend;
    toSend.append(QString::number(consigneVG));
    toSend.append("_");
    toSend.append(QString::number(accG));
    toSend.append("_");
    toSend.append(QString::number(consigneVD));
    toSend.append("_");
    toSend.append(QString::number(accD));
    threadMQTT->publishMessage("roboclaw/o2r/set/motor/m1/speed/value", toSend);
}

int GestionRoboclaw::getConsigneVD() const
{
    return consigneVD;
}

void GestionRoboclaw::setConsigneVD(int value)
{
    consigneVD = value;
    QString toSend;
    toSend.append(QString::number(consigneVG));
    toSend.append("_");
    toSend.append(QString::number(accG));
    toSend.append("_");
    toSend.append(QString::number(consigneVD));
    toSend.append("_");
    toSend.append(QString::number(accD));
    threadMQTT->publishMessage("roboclaw/o2r/set/motor/m2/speed/value", toSend);
}

int GestionRoboclaw::getCoeffDd() const
{
    return coeffDd;
}

void GestionRoboclaw::setCoeffDd(int value)
{
    coeffDd = value;
    saveParam();

    QString toSend;
    toSend.append(QString::number(coeffPd));
    toSend.append("_");
    toSend.append(QString::number(coeffId));
    toSend.append("_");
    toSend.append(QString::number(coeffDd));
    toSend.append("_");
    toSend.append(QString::number(QPPSMaxD));
    threadMQTT->publishMessage("roboclaw/o2r/set/motor/m2/d", toSend);
}

int GestionRoboclaw::getCoeffId() const
{
    return coeffId;
}

void GestionRoboclaw::setCoeffId(int value)
{
    coeffId = value;
    saveParam();
    QString toSend;
    toSend.append(QString::number(coeffPd));
    toSend.append("_");
    toSend.append(QString::number(coeffId));
    toSend.append("_");
    toSend.append(QString::number(coeffDd));
    toSend.append("_");
    toSend.append(QString::number(QPPSMaxD));
    threadMQTT->publishMessage("roboclaw/o2r/set/motor/m2/i", toSend);
}

int GestionRoboclaw::getCoeffPd() const
{
    return coeffPd;
}

void GestionRoboclaw::setCoeffPd(int value)
{
    coeffPd = value;
    saveParam();
    QString toSend;
    toSend.append(QString::number(coeffPd));
    toSend.append("_");
    toSend.append(QString::number(coeffId));
    toSend.append("_");
    toSend.append(QString::number(coeffDd));
    toSend.append("_");
    toSend.append(QString::number(QPPSMaxD));
    qDebug()<<"toPublish : "<<toSend;
    threadMQTT->publishMessage("roboclaw/o2r/set/motor/m2/p", toSend);
}

int GestionRoboclaw::getCoeffDg() const
{
    return coeffDg;
}

void GestionRoboclaw::setCoeffDg(int value)
{
    coeffDg = value;
    saveParam();
    QString toSend;
    toSend.append(QString::number(coeffPg));
    toSend.append("_");
    toSend.append(QString::number(coeffIg));
    toSend.append("_");
    toSend.append(QString::number(coeffDg));
    toSend.append("_");
    toSend.append(QString::number(QPPSMaxG));
    threadMQTT->publishMessage("roboclaw/o2r/set/motor/m1/d", toSend);
}

int GestionRoboclaw::getCoeffIg() const
{
    return coeffIg;
}

void GestionRoboclaw::setCoeffIg(int value)
{
    coeffIg = value;
    saveParam();
    QString toSend;
    toSend.append(QString::number(coeffPg));
    toSend.append("_");
    toSend.append(QString::number(coeffIg));
    toSend.append("_");
    toSend.append(QString::number(coeffDg));
    toSend.append("_");
    toSend.append(QString::number(QPPSMaxG));
    threadMQTT->publishMessage("roboclaw/o2r/set/motor/m1/i", toSend);
}

int GestionRoboclaw::getCoeffPg() const
{
    return coeffPg;
}

void GestionRoboclaw::setCoeffPg(int value)
{
    coeffPg = value;
    saveParam();
    QString toSend;
    toSend.append(QString::number(coeffPg));
    toSend.append("_");
    toSend.append(QString::number(coeffIg));
    toSend.append("_");
    toSend.append(QString::number(coeffDg));
    toSend.append("_");
    toSend.append(QString::number(QPPSMaxG));
    threadMQTT->publishMessage("roboclaw/o2r/set/motor/m1/p", toSend);
}

void GestionRoboclaw::saveParam()
{
    QFile saveFile("data/config.json");
    if(!saveFile.open(QIODevice::ReadWrite))
    {
        qDebug()<<"Failed !";
    }else
    {
        saveFile.flush();
        saveFile.resize(0);
        QJsonObject saveObject;
        saveObject["coeffPG"] = coeffPg;
        saveObject["coeffIG"] = coeffIg;
        saveObject["coeffDG"] = coeffDg;
        saveObject["coeffPD"] = coeffPd;
        saveObject["coeffID"] = coeffId;
        saveObject["coeffDD"] = coeffDd;
        saveObject["QPPSMaxG"] = QPPSMaxG;
        saveObject["QPPSMaxD"] = QPPSMaxD;
        saveObject["accG"] = accG;
        saveObject["accD"] = accD;
        QJsonObject roboclawObject;
        roboclawObject["Roboclaw"] = saveObject;
        QJsonDocument saveDoc(roboclawObject);
        saveFile.write(saveDoc.toJson());
    }

    saveFile.close();
}

void GestionRoboclaw::init()
{
    QFile loadFile("data/config.json");
    if(!loadFile.open(QIODevice::ReadOnly))
    {
        qDebug()<<"Failed !";
    }else
    {
        QByteArray saveData = loadFile.readAll();
        QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));
        QJsonObject json = loadDoc.object();

        if (json.contains("Roboclaw") )
        {
            if(json["Roboclaw"].isObject())
            {
                QJsonObject roboclaw = json["Roboclaw"].toObject();

                if(roboclaw.contains("coeffPG") )
                {
                    coeffPg = roboclaw["coeffPG"].toInt();
                }
                if(roboclaw.contains("coeffIG") )
                {
                    coeffIg = roboclaw["coeffIG"].toInt();
                }
                if(roboclaw.contains("coeffDG") )
                {
                    coeffDg = roboclaw["coeffDG"].toInt();
                }

                if(roboclaw.contains("coeffPD") )
                {
                    coeffPd = roboclaw["coeffPD"].toInt();
                }
                if(roboclaw.contains("coeffID") )
                {
                    coeffId = roboclaw["coeffID"].toInt();
                }
                if(roboclaw.contains("coeffDD") )
                {
                    coeffDd = roboclaw["coeffDD"].toInt();
                }

                if(roboclaw.contains("accG") )
                {
                    accG = roboclaw["accG"].toInt();
                }
                if(roboclaw.contains("accD") )
                {
                    accD = roboclaw["accD"].toInt();
                }
                if(roboclaw.contains("QPPSMaxG") )
                {
                    QPPSMaxG = roboclaw["QPPSMaxG"].toInt();
                }
                if(roboclaw.contains("QPPSMaxD") )
                {
                    QPPSMaxD = roboclaw["QPPSMaxD"].toInt();
                }
            }

        }else
        {

        }

        loadFile.close();
        emit initDone();
    }
}

int GestionRoboclaw::getAccG() const
{
    return accG;
}

void GestionRoboclaw::setAccG(int value)
{
    accG = value;
    saveParam();
    threadMQTT->publishMessage("AccG", QString::number(value));
}

int GestionRoboclaw::getAccD() const
{
    return accD;
}

void GestionRoboclaw::setAccD(int value)
{
    accD = value;
    saveParam();
    threadMQTT->publishMessage("AccD", QString::number(value));
}



int GestionRoboclaw::connectToRobot()
{
    if(isInit == 0 )
    {
        qDebug()<<"A";
        threadMQTT->start();
        connect(threadMQTT, SIGNAL(onConnect()), this, SLOT(onMQTTConnected()));
        connect(threadMQTT, SIGNAL(vitesseGChanged(int)), this, SLOT(setVitesseGauche(int)));
        connect(threadMQTT, SIGNAL(vitesseDChanged(int)), this, SLOT(setVitesseDroite(int)));
        connect(threadMQTT, SIGNAL(codeurGChanged(int)), this, SLOT(setCodeurGauche(int)));
        connect(threadMQTT, SIGNAL(codeurDChanged(int)), this, SLOT(setCodeurDroit(int)));

        return 0;
    }else
    {
        //client->arret();
        return 1;
    }
}

void GestionRoboclaw::onMQTTConnected()
{
    isInit = 1;
    threadMQTT->subscribeTo("roboclaw/r2o/get/codeur/m1/value");
    threadMQTT->subscribeTo("roboclaw/r2o/get/codeur/m2/value");
    threadMQTT->subscribeTo("roboclaw/r2o/get/motor/m1/speed/value");
    threadMQTT->subscribeTo("roboclaw/r2o/get/motor/m2/speed/value");
}
