#ifndef ITEMTAUX_H
#define ITEMTAUX_H

#include <QQuickItem>

class ItemTaux : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(int param READ getParam WRITE setParam NOTIFY paramChanged)
    Q_PROPERTY(int condition READ getCondition WRITE setCondition NOTIFY conditionChanged)
    Q_PROPERTY(int valeur READ getValeur WRITE setValeur NOTIFY valeurChanged)
    Q_PROPERTY(int taux READ getTaux WRITE setTaux NOTIFY tauxChanged)
public:
    ItemTaux();

    int getParam() const;
    int getCondition() const;
    int getValeur() const;
    int getTaux() const;

public slots:
    void setParam(int value);
    void setCondition(int value);
    void setValeur(int value);
    void setTaux(int value);

signals:
    void paramChanged();
    void conditionChanged();
    void valeurChanged();
    void tauxChanged();

private:
    int param;
    int condition;
    int valeur;
    int taux;

};

#endif // ITEMTAUX_H
