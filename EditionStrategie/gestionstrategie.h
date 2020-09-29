#ifndef GESTIONSTRATEGIE_H
#define GESTIONSTRATEGIE_H

#include <QObject>
#include <QList>
#include <QMap>
#include <QDir>
#include "etape.h"
#include "position.h"

#include "../EditionSequence/editableaction.h"

class GestionStrategie : public QObject
{
    Q_OBJECT
public:
    explicit GestionStrategie(QObject *parent = nullptr);

public slots:
    void addEtape(Etape *);
    void addPosition(Position *);
    void removeEtape(Etape * etape);
    Etape* getEtape(int);
    Etape* getEtape(Etape *);
    void clearList();
    void saveStrategie(QString nomFile);
    void updateStrat();
    int getNbStrat();
    QString getNameStrat(int indice);
    void openStrat(QString nomStrat);
    void exportStrat();
    int getNbEtape();


signals:
    void nouvelleEtape(QString nom, int nbPoints, int tempsMoyen, int tempsMax, int dateMax,
                       int deadLine, int x, int y, QString color, QString nameSequence);
    void nouveauTaux(int indice, int param, int cond, int value, int ratio);

    void nouvellePosition(int x, int y);
    void updateAllLiaison();
    void clearAllLists();

private:
    QList <Etape *> listEtape;
    QList <Position *> listPosition;
    QList <QString> listStrat;
    QList <EditableAction *> listAction;
    int appendSequence(QString filename, int indiceSequence);
    QJsonArray exportSequence(QString filename);
    QMap<int, bool> mapIndice;

};

#endif // GESTIONSTRATEGIE_H
