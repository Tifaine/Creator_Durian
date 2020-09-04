#ifndef GESTIONSIMULATION_H
#define GESTIONSIMULATION_H

#include <QObject>
#include <QList>
#include "../EditionStrategie/etape.h"
#include "threaddeplacement.h"

#define NB_MAX_VERRES           12


class GestionSimulation : public QObject
{
    Q_OBJECT
public:
    explicit GestionSimulation(QObject *parent = nullptr);

public slots:
    void openStrat(QString filename);
    void addEtape(Etape * step);
    void deleteEtape(Etape * step);
    void clearAll();
    void lancerSimulation();

private slots:
    void onArriveOnStep();

private:

    float calcDistanceToEtape(int _xRobot, int _yRobot, int _xStep, int _yStep);
    int getIndicePlusProche();

signals:
    void nouvelleEtape(QString nom, int nbPoints,
                       int tempsMoyen, int tempsMax,
                       int dateMax, int deadLine, int x, int y,
                       QString color, QString nameSequence);
    void nouveauTaux(int indice, int param, int cond, int value, int ratio);
    void clearListEtape();
    void updatePosRobot(int x, int y);

private:
    int xRobot;
    int yRobot;
    int nbVerresVerts;
    int nbVerresRouges;

    int nbMinVerreDepose;
    QList<Etape *> listEtape;
    ThreadDeplacement * mThreadDeplacement;

};

#endif // GESTIONSIMULATION_H
