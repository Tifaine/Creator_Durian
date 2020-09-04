#ifndef THREADDEPLACEMENT_H
#define THREADDEPLACEMENT_H
#include <QTimer>
#include <QDebug>

#define _VITESSE_ROBOT 1000
#define _PRECISION 35

class ThreadDeplacement : public QObject
{
    Q_OBJECT
public:
    explicit ThreadDeplacement(QObject *parent = nullptr);
    void setPosition(int x, int y);
    void setCible(int x, int y);
    void start();

    int getEtapeEnCours() const;
    void setEtapeEnCours(int value);

    int getMxRobot() const;
    void setMxRobot(int value);

    int getMyRobot() const;
    void setMyRobot(int value);

private slots:
    void updateDeplacement();

signals:
    void arriveOnStep();
    void updatePosRobot(int x, int y);

private:
    QTimer *timer;
    int mxRobot;
    int myRobot;
    int mxCible;
    int myCible;
    int etapeEnCours;

};

#endif // THREADDEPLACEMENT_H
