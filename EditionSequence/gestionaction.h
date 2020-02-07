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
    int getNbParameter(int indiceAction);
    QString getNomParam(int indiceAction, int indiceParam);
    QString getDefaultValueParam(int indiceAction, int indiceParam);
    int getIsActionBlocante(int indice);

    int getNbAlias(int indiceAction, int indiceParam);
    QString getNomAlias(int indiceAction, int indiceParam, int indiceAlias);
    QString getValueAlias(int indiceAction, int indiceParam, int indiceAlias);
    Action* getAction(int indice);
    int getIndiceByName(QString name);

signals:
    void nouvelleAction(QString name, int isBlocante);
    void addParam(QString name, QString defaultValue);
    void addAlias(int indiceParam, int indiceAlias, QString name, QString value);
    void actionsUpdated();

private:
    void init();

private:
    QList<Action* > listAction;

};

#endif // GESTIONACTION_H
