#include "action.h"

Action::Action()
{

}

QString Action::getNomAction() const
{
    return nomAction;
}

void Action::setNomAction(const QString &value)
{
    nomAction = value;
}

bool Action::getIsActionBlocante() const
{
    return isActionBlocante;
}

void Action::setIsActionBlocante(bool value)
{
    isActionBlocante = value;
}

void Action::addParam()
{
    listParam.append(new param);
}

int Action::getNbParam()
{
    return listParam.size();
}

param* Action::getParam(int indice)
{
    return listParam.at(indice);
}

void Action::setNomParam(int indiceParam, QString nomParam)
{
    listParam.at(indiceParam)->nomParam = nomParam;
}

QString Action::getNomParam(int indiceParam)
{
    return listParam.at(indiceParam)->nomParam;
}

void Action::setValueDefaultParam(int indiceParam, QString valueDefault)
{
    listParam.at(indiceParam)->valueParam = valueDefault;
}

QString Action::getValueDefaultParam(int indiceParam)
{
    return listParam.at(indiceParam)->valueParam;
}

void Action::addAlias(int indiceParam)
{
    listParam.at(indiceParam)->listAlias.append(new alias);
}

int Action::getnbAlias(int indiceParam)
{
    return listParam.at(indiceParam)->listAlias.size();
}

alias* Action::getAlias(int indiceParam, int indiceAlias)
{
    return listParam.at(indiceParam)->listAlias.at(indiceAlias);
}

void Action::setNomAlias(int indiceParam, int indiceAlias, QString nom)
{
    listParam.at(indiceParam)->listAlias.at(indiceAlias)->nomAlias = nom;
}

QString Action::getNomAlias(int indiceParam, int indiceAlias)
{
    return listParam.at(indiceParam)->listAlias.at(indiceAlias)->nomAlias;
}

void Action::setValueAlias(int indiceParam, int indiceAlias, QString value)
{
    listParam.at(indiceParam)->listAlias.at(indiceAlias)->valueAlias = value;
}

QString Action::getValueAlias(int indiceParam, int indiceAlias)
{
    return listParam.at(indiceParam)->listAlias.at(indiceAlias)->valueAlias;
}
