#include "position.h"
#include "etape.h"

Position::Position() :
    x(0),
    y(0)
{

}

int Position::getX() const
{
    return x;
}

void Position::setX(int value)
{
    x = value;
}

int Position::getY() const
{
    return y;
}

void Position::setY(int value)
{
    y = value;
}

int Position::getIndex() const
{
    return index;
}

void Position::setIndex(int value)
{
    index = value;
}


bool Position::containsEtape(Etape* mStep)
{
    return listEtapesLiees.contains(mStep);
}

bool Position::containsPosition(Position* mPos)
{
    return listPositionsLiees.contains(mPos);
}

void Position::addEtapeLiee(Etape* mStep)
{
    listEtapesLiees.append(mStep);
}

void Position::addPositionLiee(Position* mPos)
{
    listPositionsLiees.append(mPos);
}

int Position::getNbPositionLiee()
{
    return listPositionsLiees.count();
}

int Position::getNbEtapeLiee()
{
    return listEtapesLiees.count();
}

Position* Position::getPosition(int _index)
{
    if (getNbPositionLiee() > _index)
    {
        return listPositionsLiees.at(_index);
    }
    return NULL;
}


Etape* Position::getEtape(int _index)
{
    if (getNbEtapeLiee() > _index)
    {
        return listEtapesLiees.at(_index);
    }
    return NULL;
}


