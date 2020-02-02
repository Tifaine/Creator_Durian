#ifndef GESTIONSTRATEGIE_H
#define GESTIONSTRATEGIE_H

#include <QObject>
#include <QList>
#include <QDir>
#include "etape.h"

class GestionStrategie : public QObject
{
    Q_OBJECT
public:
    explicit GestionStrategie(QObject *parent = nullptr);

public slots:
    void addEtape(Etape *);
    Etape* getEtape(int);
    Etape* getEtape(Etape *);
    void clearList();
    void saveStrategie(QString nomFile);
    void updateStrat();
    int getNbStrat();
    QString getNameStrat(int indice);
    void openStrat(QString nomStrat);
    int getNbEtape();


signals:
    void nouvelleEtape(QString nom, int nbPoints, int tempsMoyen, int tempsMax, int dateMax, int deadLine, int x, int y, QString color, QString nameSequence);
    void nouveauTaux(int indice, int param, int cond, int value, int ratio);

private:
    QList <Etape *> listEtape;
    QList <QString> listStrat;

};

#endif // GESTIONSTRATEGIE_H
