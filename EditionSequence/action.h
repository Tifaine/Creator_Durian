#ifndef ACTION_H
#define ACTION_H

#include <QQuickItem>
#include <QList>
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

typedef struct alias
{
    QString nomAlias;
    QString valueAlias;
}alias;

typedef struct param
{
    QString nomParam;
    QString valueParam;
    QList<alias* > listAlias;
}param;



class Action : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QString nomAction READ getNomAction WRITE setNomAction NOTIFY nomActionChanged)
    Q_PROPERTY(bool isActionBlocante READ getIsActionBlocante WRITE setIsActionBlocante NOTIFY isActionBlocanteChanged)
public:
    Action();

public slots:
    QString getNomAction() const;
    void setNomAction(const QString &value);
    bool getIsActionBlocante() const;
    void setIsActionBlocante(bool value);

    void addParam();
    int getNbParam();
    param* getParam(int indice);
    void setNomParam(int indiceParam, QString nomParam);
    QString getNomParam(int indiceParam);
    void setValueDefaultParam(int indiceParam, QString valueDefault);
    QString getValueDefaultParam(int indiceParam);

    void addAlias(int indiceParam);
    int getnbAlias(int indiceParam);
    alias* getAlias(int indiceParam, int indiceAlias);
    void setNomAlias(int indiceParam, int indiceAlias, QString nom);
    QString getNomAlias(int indiceParam, int indiceAlias);
    void setValueAlias(int indiceParam, int indiceAlias, QString value);
    QString getValueAlias(int indiceParam, int indiceAlias);

    void save();
    QJsonObject saveAction();
    void loadAction(QJsonObject json);
    void clearAlias(int indiceParam);

signals:
    void nomActionChanged();
    void isActionBlocanteChanged();

private:
    QString nomAction;
    bool isActionBlocante;
    QList<param* > listParam;

};

#endif // ACTION_H
