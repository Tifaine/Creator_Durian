#ifndef GESTIONDYNAMIXEL_H
#define GESTIONDYNAMIXEL_H

#include <QObject>
#include <QList>

typedef struct dyna
{
    int id;
    int value;
    int speed;
    QString name;
}dyna;

class GestionDynamixel : public QObject
{
    Q_OBJECT
public:
    explicit GestionDynamixel(QObject *parent = nullptr);

public slots:
    int getNbDyna();
    int getIdDyna(int indice);
    int getValueDyna(int indice);
    int getSpeedDyna(int indice);
    QString getNameDyna(int indice);

    void setValueDyna(int indice, int value);
    void setVitesseDyna(int indice, int value);

    void saveDyna(int indice);
    void updateListDyna();

signals:
    void listDynaUpdated();

private:
    void init();
private:
    QList<dyna *> listDyna;

signals:

};

#endif // GESTIONDYNAMIXEL_H
