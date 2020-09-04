#ifndef POSITION_H
#define POSITION_H

#include <QQuickItem>
#include <QList>

class Etape;

class Position : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(int x READ getX WRITE setX NOTIFY xModified)
    Q_PROPERTY(int y READ getY WRITE setY NOTIFY yModified)
    Q_PROPERTY(int index READ getIndex WRITE setIndex NOTIFY indexModified)
public:
    Position();

public slots:

    int getX() const;
    void setX(int value);

    int getY() const;
    void setY(int value);

    int getIndex() const;
    void setIndex(int value);

    bool containsEtape(Etape* mStep);
    bool containsPosition(Position* mPos);
    void addEtapeLiee(Etape* mStep);
    void addPositionLiee(Position* mPos);

    int getNbPositionLiee();
    int getNbEtapeLiee();

    Position* getPosition(int _index);
    Etape* getEtape(int _index);

signals:
    void xModified();
    void yModified();
    void indexModified();
    void mustUpdateLiaison();

private:
    int x;
    int y;
    int index;

    QList<Position *> listPositionsLiees;
    QList<Etape *> listEtapesLiees;

};

#endif // POSITION_H
