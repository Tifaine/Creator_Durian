#include "threaddeplacement.h"
#include <QtMath>

ThreadDeplacement::ThreadDeplacement(QObject *parent) : QObject(parent)
{
    timer = new QTimer();
}

void ThreadDeplacement::updateDeplacement()
{
    float distanceCible = qSqrt(qPow(mxCible - mxRobot, 2) +qPow(myCible - myRobot, 2) );

    if(qAbs(distanceCible) < _PRECISION)
    {
        emit arriveOnStep();
    }else
    {
        float angleCibleRobot = qAcos((mxCible - mxRobot ) / distanceCible);
        float distanceParcourue = _VITESSE_ROBOT * 50/1000;
        mxRobot += distanceParcourue * qCos(angleCibleRobot);

        if(myRobot > myCible)
        {
            myRobot -= distanceParcourue * qSin(angleCibleRobot);
        }else
        {
            myRobot += distanceParcourue * qSin(angleCibleRobot);
        }

        emit updatePosRobot(mxRobot, myRobot);

    }
    qDebug()<<mxRobot<<" "<<myRobot<<" "<<distanceCible<<" "<<mxCible<<" "<<myCible;
}

int ThreadDeplacement::getMyRobot() const
{
    return myRobot;
}

void ThreadDeplacement::setMyRobot(int value)
{
    myRobot = value;
}

int ThreadDeplacement::getMxRobot() const
{
    return mxRobot;
}

void ThreadDeplacement::setMxRobot(int value)
{
    mxRobot = value;
}

int ThreadDeplacement::getEtapeEnCours() const
{
    return etapeEnCours;
}

void ThreadDeplacement::setEtapeEnCours(int value)
{
    etapeEnCours = value;
}

void ThreadDeplacement::setPosition(int x, int y)
{
    mxRobot =  x;
    myRobot =  y;
}

void ThreadDeplacement::setCible(int x, int y)
{
    mxCible =  x;
    myCible =  y;
}

void ThreadDeplacement::start()
{
    if(! (timer->isActive()))
    {
        connect(timer, &QTimer::timeout, this, QOverload<>::of(&ThreadDeplacement::updateDeplacement));
        timer->start(50);
    }
}
