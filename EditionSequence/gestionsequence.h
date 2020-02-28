#ifndef GESTIONSEQUENCE_H
#define GESTIONSEQUENCE_H

#include <QQuickItem>
#include <QList>
#include <QDir>
#include <QFileSystemWatcher>
#include "editableaction.h"

class GestionSequence : public QQuickItem
{
    Q_OBJECT
public:
    explicit GestionSequence();

public slots:
    void addAction( EditableAction * act);
    void eraseAction( EditableAction * act);
    void save(QString nomFile);
    void open(QString nomFile);
    void clearAction();
    int getNbSequence();
    QString getNomSequence(int indice);

private slots:
    void onDirectoryChanged(const QString &path);

signals:
    void createNewAction(QString nomAction, int xBloc, int yBloc);
    void updateParam(int indiceParam, QString value);
    void ajoutFille(int indicePere, int indiceFille);
    void ajoutTimeout(int indicePere, int indiceTimeout);
    void listFilesChanged();

private:
    QList<EditableAction* > listAction;
    QStringList listSequence;
    QFileSystemWatcher watcher;

};

#endif // GESTIONSEQUENCE_H
