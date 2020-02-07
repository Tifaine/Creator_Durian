#ifndef GESTIONSEQUENCE_H
#define GESTIONSEQUENCE_H

#include <QQuickItem>
#include <QList>
#include "editableaction.h"

class GestionSequence : public QQuickItem
{
    Q_OBJECT
public:
    explicit GestionSequence();

public slots:
    void addAction( EditableAction * act);
    void save(QString nomFile);
    void open(QString nomFile);
    void clearAction();

signals:
    void createNewAction(QString nomAction, int xBloc, int yBloc);
    void updateParam(int indiceParam, QString value);
    void ajoutFille(int indicePere, int indiceFille);
    void ajoutTimeout(int indicePere, int indiceTimeout);

private:
    QList<EditableAction* > listAction;

};

#endif // GESTIONSEQUENCE_H
