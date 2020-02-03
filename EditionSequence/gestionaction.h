#ifndef GESTIONACTION_H
#define GESTIONACTION_H

#include <QObject>
#include <QList>
#include <QDir>
#include "action.h"

class GestionAction : public QObject
{
    Q_OBJECT
public:
    explicit GestionAction(QObject *parent = nullptr);

public slots:
    void addAction(Action* etape);
    void updateAction();
    int getNbAction();
    QString getNameAction(int indice);

signals:
    void nouvelleAction(QString name, int isBlocante);
    void addParam(QString name, QString defaultValue);
    void addAlias(int indiceParam, int indiceAlias, QString name, QString value);
    void actionsUpdated();
private:
    QList<Action* > listAction;

};

#endif // GESTIONACTION_H
