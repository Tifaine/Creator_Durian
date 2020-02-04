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
    void clearAction();

signals:

private:
    QList<EditableAction* > listAction;

};

#endif // GESTIONSEQUENCE_H
