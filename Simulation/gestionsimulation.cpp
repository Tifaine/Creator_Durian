#include "gestionsimulation.h"
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QtMath>

GestionSimulation::GestionSimulation(QObject *parent) : QObject(parent)
{
    mThreadDeplacement = new ThreadDeplacement;

    connect(mThreadDeplacement, SIGNAL(arriveOnStep()), this, SLOT(onArriveOnStep()));
    connect(mThreadDeplacement, SIGNAL(updatePosRobot(int, int)), this, SIGNAL(updatePosRobot(int, int)));
    nbVerresVerts = 0;
    nbVerresRouges = 0;
    nbMinVerreDepose = 4;
}

void GestionSimulation::openStrat(QString filename)
{
    emit clearListEtape();
    QFile loadFile("data/Strategie/"+filename+".json");
    if(!loadFile.open(QIODevice::ReadOnly))
    {
        qDebug()<<"Failed ! "<<Q_FUNC_INFO;
    }else
    {
        QByteArray saveData = loadFile.readAll();
        QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));
        QJsonObject json = loadDoc.object();
        if (json.contains("Strategie") )
        {
            if(json["Strategie"].isArray())
            {
                QJsonArray array = json["Strategie"].toArray();
                int indice = 0;
                foreach (const QJsonValue & v, array)
                {
                    Etape foo;
                    foo.loadObject(v.toObject());
                    emit nouvelleEtape(foo.getNomEtape(), foo.getNbPoints(), foo.getTempsMoyen(), foo.getTempsMax(), foo.getDateMax(), foo.getDeadline(), foo.getX(), foo.getY(), foo.getColor(), foo.getNameSequence());

                    for(int i=0; i<foo.getNbTaux();i++)
                    {
                        emit nouveauTaux(indice, foo.getParamTaux(i), foo.getCondTaux(i), foo.getValueTaux(i), foo.getRatioTaux(i));
                    }
                    indice++;
                }
            }
        }
    }
}

void GestionSimulation::addEtape(Etape * step)
{
    listEtape.append(step);
}

void GestionSimulation::deleteEtape(Etape * step)
{
    listEtape.removeAll(step);
}

void GestionSimulation::clearAll()
{
    listEtape.clear();
}

void GestionSimulation::lancerSimulation()
{
    for(int i = 0; i < listEtape.count(); i++)
    {
        if(listEtape.at(i)->getNomEtape() == "initBleu")
        {
            xRobot = listEtape.at(i)->getX();
            yRobot = listEtape.at(i)->getY();
            mThreadDeplacement->setPosition(xRobot, yRobot);
        }
    }

    int indice = getIndicePlusProche();
    mThreadDeplacement->setEtapeEnCours(indice);
    mThreadDeplacement->setCible(listEtape.at(indice)->getX(), listEtape.at(indice)->getY());

    mThreadDeplacement->start();
}

void GestionSimulation::onArriveOnStep()
{
    int indice = mThreadDeplacement->getEtapeEnCours();

    if(listEtape.at(indice)->getNomEtape() == "verreVert")
    {
        nbVerresVerts++;
    }else if(listEtape.at(indice)->getNomEtape() == "verreRouge")
    {
        nbVerresRouges++;
    }else if(listEtape.at(indice)->getNomEtape() == "multiVerres")
    {
        nbVerresVerts +=2;
        nbVerresRouges+=3;
    }else if(listEtape.at(indice)->getNomEtape() == "DeposeVerres")
    {
        nbVerresVerts = 0;
        nbVerresRouges = 0;
    }


    qDebug()<<"Etape : "<<listEtape.at(indice)->getNomEtape();
    qDebug()<<"X : "<<listEtape.at(indice)->getX()<<" Y : "<<listEtape.at(indice)->getY();
    qDebug()<<"Indice plus proche : "<<indice<<" à une distance de : "<<calcDistanceToEtape(xRobot, yRobot, listEtape.at(indice)->getX(), listEtape.at(indice)->getY());

    xRobot = mThreadDeplacement->getMxRobot();
    yRobot = mThreadDeplacement->getMyRobot();

    if(listEtape.at(indice)->getNomEtape() != "DeposeVerres")
    {
        listEtape.at(indice)->setIsDone(true);
    }
    indice = getIndicePlusProche();
    if(indice == -1 )
    {
        nbMinVerreDepose = 0;
        indice = getIndicePlusProche();
    }
    if(indice != -1)
    {
        mThreadDeplacement->setCible(listEtape.at(indice)->getX(), listEtape.at(indice)->getY());
        mThreadDeplacement->setEtapeEnCours(indice);
    }

}

float GestionSimulation::calcDistanceToEtape(int _xRobot, int _yRobot, int _xStep, int _yStep)
{
    return qSqrt(qPow(_xStep - _xRobot, 2) +qPow(_yStep - _yRobot, 2) );
}

int GestionSimulation::getIndicePlusProche()
{
    float distancePlusProche = 5000;
    int indicePlusProche = -1;
    for(int i = 0; i < listEtape.count() -1; i++)
    {
        if(listEtape.at(i)->getIsDone())
        {
            continue;
        }

        if(calcDistanceToEtape(xRobot, yRobot, listEtape.at(i)->getX(), listEtape.at(i)->getY()) < distancePlusProche)
        {
            if(listEtape.at(i)->getNomEtape() == "verreVert" || listEtape.at(i)->getNomEtape() == "verreRouge")
            {
                if(nbVerresVerts + nbVerresRouges + 1 > NB_MAX_VERRES)
                {
                    continue;
                }
            }else if(listEtape.at(i)->getNomEtape() == "multiVerres")
            {
                if(nbVerresVerts + nbVerresRouges + 5 > NB_MAX_VERRES)
                {
                    continue;
                }
            }else if(listEtape.at(i)->getNomEtape() == "DeposeVerres")
            {
                if(nbVerresVerts + nbVerresRouges < nbMinVerreDepose)
                {
                    continue;
                }
            }

            indicePlusProche = i;
            distancePlusProche = calcDistanceToEtape(xRobot, yRobot, listEtape.at(i)->getX(), listEtape.at(i)->getY());
        }
    }

    return indicePlusProche;
}
