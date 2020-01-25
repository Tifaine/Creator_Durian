#include "etape.h"

Etape::Etape()
{

}

int Etape::getYEtape() const
{
    return yEtape;
}

QString Etape::getDescription() const
{
    return description;
}

void Etape::setDescription(const QString &value)
{
    description = value;
}

int Etape::getType() const
{
    return type;
}

void Etape::setType(int value)
{
    type = value;
}

void Etape::setYEtape(int value)
{
    yEtape = value;
}

int Etape::getXEtape() const
{
    return xEtape;
}

void Etape::setXEtape(int value)
{
    xEtape = value;
}

QString Etape::getNomEtape() const
{
    return nomEtape;
}

void Etape::setNomEtape(const QString &value)
{
    nomEtape = value;
}
