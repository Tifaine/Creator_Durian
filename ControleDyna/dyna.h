#ifndef DYNA_H
#define DYNA_H

#include <QQuickItem>

class Dyna : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QString nom READ getNom WRITE setNom NOTIFY nomChanged)
    Q_PROPERTY(int mid READ getId WRITE setId NOTIFY idChanged)
    Q_PROPERTY(int mValue READ getValue WRITE setValue NOTIFY valueChanged)
    Q_PROPERTY(int vitesse READ getVitesse WRITE setVitesse NOTIFY vitesseChanged)

public:
    Dyna();

public slots:

    int getId() const;
    void setId(int value);

    int getValue() const;
    void setValue(int value);

    int getVitesse() const;
    void setVitesse(int value);

    QString getNom() const;
    void setNom(const QString &value);

signals:
    void nomChanged();
    void idChanged();
    void valueChanged();
    void vitesseChanged();

private:
    QString nom;
    int mid;
    int mValue;
    int vitesse;
};

#endif // DYNA_H
