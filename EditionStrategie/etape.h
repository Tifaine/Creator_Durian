#ifndef ETAPE_H
#define ETAPE_H

#include <QQuickItem>

class Etape : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QString nomEtape READ getNomEtape WRITE setNomEtape NOTIFY nomEtapeChanged)
    Q_PROPERTY(QString description READ getDescription WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(int xEtape READ getXEtape WRITE setXEtape NOTIFY xEtapeChanged)
    Q_PROPERTY(int yEtape READ getYEtape WRITE setYEtape NOTIFY yEtapeChanged)
    Q_PROPERTY(int type READ getType WRITE setType NOTIFY typeChanged)
public:
    Etape();

    void setXEtape(int);
    void setYEtape(int);

    QString getNomEtape() const;
    QString getDescription() const;

signals:
    void xEtapeChanged();
    void yEtapeChanged();
    void nomEtapeChanged();
    void descriptionChanged();
    void typeChanged();

public slots:
    int getXEtape() const;
    int getYEtape() const;
    int getType() const;
    void setType(int value);
    void setNomEtape(const QString &value);
    void setDescription(const QString &value);

private:
    int xEtape;
    int yEtape;
    int type;
    QString nomEtape;
    QString description;

};

#endif // ETAPE_H
