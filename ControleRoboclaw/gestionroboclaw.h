#ifndef GESTIONROBOCLAW_H
#define GESTIONROBOCLAW_H

#include <QObject>
#include "../threadmqtt.h"

class GestionRoboclaw : public QObject
{
    Q_OBJECT
public:
    GestionRoboclaw();

public slots:

    void saveParam();

    int getCoeffPg() const;
    void setCoeffPg(int value);

    int getCoeffIg() const;
    void setCoeffIg(int value);

    int getCoeffDg() const;
    void setCoeffDg(int value);

    int getCoeffPd() const;
    void setCoeffPd(int value);

    int getCoeffId() const;
    void setCoeffId(int value);

    int getCoeffDd() const;
    void setCoeffDd(int value);


    int getCodeurGauche() const;
    void setCodeurGauche(int value);

    int getCodeurDroit() const;
    void setCodeurDroit(int value);

    int getVitesseGauche() const;
    void setVitesseGauche(int value);

    int getVitesseDroite() const;
    void setVitesseDroite(int value);

    int getQPPSMaxG() const;
    void setQPPSMaxG(int value);

    int getQPPSMaxD() const;
    void setQPPSMaxD(int value);

    int getConsigneVG() const;
    void setConsigneVG(int value);

    int getConsigneVD() const;
    void setConsigneVD(int value);

    int getAccD() const;
    void setAccD(int value);

    int getAccG() const;
    void setAccG(int value);

    void init();
    int connectToRobot();
signals:
    void codeurGaucheChanged(int value);
    void codeurDroitChanged(int value);
    void vitesseGaucheChanged(int value);
    void vitesseDroitChanged(int value);

    void initDone();

private slots:
    void onMQTTConnected();

private:

    int codeurGauche;
    int codeurDroit;
    int vitesseGauche;
    int vitesseDroite;

    int coeffPg;
    int coeffIg;
    int coeffDg;

    int coeffPd;
    int coeffId;
    int coeffDd;

    int QPPSMaxG;
    int QPPSMaxD;

    int accG;
    int accD;

    int consigneVG;
    int consigneVD;

    bool isInit;

    ThreadMQTT *threadMQTT;
};

#endif // GESTIONROBOCLAW_H
