#ifndef GESTIONETAPE_H
#define GESTIONETAPE_H

#include <QObject>
#include <QList>
#include <QDir>

#include "etape.h"

class GestionEtape : public QObject
{
    Q_OBJECT
public:
    explicit GestionEtape(QObject *parent = nullptr);

public slots:
    void addEtape(Etape* etape);
    Etape* getEtape(int indice);

    QString getNomEtape(int indice);
    int getNbPointEtape(int indice);
    int getTempsMoyenEtape(int indice);
    int getTempsMaxEtape(int indice);
    int getDateMaxEtape(int indice);
    int getDeadLineEtape(int indice);
    QString getColorEtape(int indice);
    QString getNomSequenceEtape(int indice);

    int getIndiceEtape(Etape * etape);
    int getNbEtape();
    void createNewEtape();

    void toPrint();
    void updateEtape();
signals:
    void stepUpdated();

private:

private:
    QList<Etape* > listEtape;


};

#endif // GESTIONETAPE_H
