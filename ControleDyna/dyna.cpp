#include "dyna.h"

Dyna::Dyna()
{

}

int Dyna::getId() const
{
    return mid;
}

void Dyna::setId(int value)
{
    mid = value;
    emit idChanged();
}

int Dyna::getValue() const
{
    return mValue;
}

void Dyna::setValue(int value)
{
    mValue = value;
    valueChanged();
}

int Dyna::getVitesse() const
{
    return vitesse;
}

void Dyna::setVitesse(int value)
{
    vitesse = value;
    vitesseChanged();
}

QString Dyna::getNom() const
{
    return nom;
}

void Dyna::setNom(const QString &value)
{
    nom = value;
    nomChanged();
}
