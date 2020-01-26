#include "itemtaux.h"

ItemTaux::ItemTaux()
{

}

int ItemTaux::getParam() const
{
    return param;
}

void ItemTaux::setParam(int value)
{
    param = value;
}

int ItemTaux::getCondition() const
{
    return condition;
}

void ItemTaux::setCondition(int value)
{
    condition = value;
}

int ItemTaux::getValeur() const
{
    return valeur;
}

void ItemTaux::setValeur(int value)
{
    valeur = value;
}

int ItemTaux::getTaux() const
{
    return taux;
}

void ItemTaux::setTaux(int value)
{
    taux = value;
}
