#include "gestionsequence.h"

GestionSequence::GestionSequence()
{

}

void GestionSequence::addAction( EditableAction * act)
{
    listAction.append(act);
}

void GestionSequence::save(QString nomFile)
{
    for (int i = 0; i < listAction.size() ; i++)
    {
        qDebug()<<listAction.at(i)->getNomAction();
    }
}

void GestionSequence::clearAction()
{
    listAction.clear();
}
