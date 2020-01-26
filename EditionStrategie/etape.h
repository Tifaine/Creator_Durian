#ifndef ETAPE_H
#define ETAPE_H

#include <QQuickItem>
#include <QList>
#include "itemtaux.h"

class Etape : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QString nomEtape READ getNomEtape WRITE setNomEtape NOTIFY nomEtapeChanged)
    Q_PROPERTY(int nbPoints READ getNbPoints WRITE setNbPoints NOTIFY nbPointsChanged)
    Q_PROPERTY(int tempsMoyen READ getTempsMoyen WRITE setTempsMoyen NOTIFY tempsMoyenChanged)
    Q_PROPERTY(int tempsMax READ getTempsMax WRITE setTempsMax NOTIFY tempsMaxChanged)
    Q_PROPERTY(int dateMax READ getDateMax WRITE setDateMax NOTIFY dateMaxChanged)
    Q_PROPERTY(int deadline READ getDeadline WRITE setDeadline NOTIFY deadlineChanged)

public:
    Etape();   

    QString getNomEtape() const;
    int getNbPoints() const;
    int getTempsMoyen() const;
    int getDeadline() const;
    int getDateMax() const;
    int getTempsMax() const;

signals:
    void nomEtapeChanged();
    void nbPointsChanged();
    void tempsMoyenChanged();
    void tempsMaxChanged();
    void dateMaxChanged();
    void deadlineChanged();

public slots:
    void setNomEtape(const QString &value);
    void setNbPoints(int value);
    void setTempsMoyen(int value);
    void setTempsMax(int value);
    void setDateMax(int value);
    void setDeadline(int value);

    void addItemTaux();

    void setParamTaux(int indice, int value);
    int getParamTaux(int indice);

    void setCondTaux(int indice, int value);
    int getCondTaux(int indice);

    void setValueTaux(int indice, int value);
    int getValueTaux(int indice);

    void setRatioTaux(int indice, int value);
    int getRatioTaux(int indice);


    int getNbTaux();

    void save();

private:
    QString nomEtape;
    int nbPoints;
    int tempsMoyen;
    int tempsMax;
    int dateMax;
    int deadline;

    QList<ItemTaux *> listTaux;

};

#endif // ETAPE_H
