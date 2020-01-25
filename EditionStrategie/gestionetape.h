#ifndef GESTIONETAPE_H
#define GESTIONETAPE_H

#include <QObject>
#include <QList>

#include "etape.h"

class GestionEtape : public QObject
{
    Q_OBJECT
public:
    explicit GestionEtape(QObject *parent = nullptr);

public slots:
    void addEtape(Etape* etape);
    Etape* getEtape(int indice);
    int getIndiceEtape(Etape * etape);

signals:

private:
    QList<Etape* > listEtape;


};

#endif // GESTIONETAPE_H
