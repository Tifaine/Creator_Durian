#include "gestionetape.h"
#include <QDebug>

GestionEtape::GestionEtape(QObject *parent) : QObject(parent)
{

}

void GestionEtape::addEtape(Etape* etape)
{
    listEtape.append(etape);
}

Etape* GestionEtape::getEtape(int indice)
{
    return listEtape.at(indice);
}

int GestionEtape::getIndiceEtape(Etape * etape)
{
    return listEtape.indexOf(etape);
}
