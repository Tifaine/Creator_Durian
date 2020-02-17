#ifndef EDITABLEACTION_H
#define EDITABLEACTION_H
#include <QQuickItem>
#include "action.h"
#include "Components/connector.h"

class EditableAction : public Action
{
    Q_OBJECT
    Q_PROPERTY(int xBloc READ getXBloc WRITE setXBloc NOTIFY xBlocChanged)
    Q_PROPERTY(int yBloc READ getYBloc WRITE setYBloc NOTIFY yBlocChanged)

    Q_PROPERTY(int xFather READ getXFather WRITE setXFather NOTIFY xFatherChanged)
    Q_PROPERTY(int yFather READ getYFather WRITE setYFather NOTIFY yFatherChanged)

    Q_PROPERTY(int xTimeOut READ getXTimeOut WRITE setXTimeOut NOTIFY xTimeoutChanged)
    Q_PROPERTY(int yTimeOut READ getYTimeOut WRITE setYTimeOut NOTIFY yTimeoutChanged)

    Q_PROPERTY(int xEntree READ getXEntree WRITE setXEntree NOTIFY xEntreeChanged)
    Q_PROPERTY(int yEntree READ getYEntree WRITE setYEntree NOTIFY yEntreeChanged)

public:
    EditableAction();

    void open1(QJsonObject json);
    void open2(QJsonObject json);
    void daughterIsMoving(EditableAction * act);
    QJsonObject saveAction();

    QList<EditableAction *> getListPere() const;

    QList<EditableAction *> getListFille() const;

    QList<EditableAction *> getListTimeOut() const;

    int getNbfille();
    int getNbTimeout();

    int getIndicefille(int indice);
    int getIndiceTimeout(int indice);
    void abandonnerFille(EditableAction * act);

public slots:

    void prepareToErase();
    void abandonnerPere(EditableAction * act);
    void abandonnerPere(int indice);
    int getNbPapa();
    void clearListFille();
    QString getNomPapa(int indice);
    int getXBloc() const;
    void setXBloc(int value);

    int getYBloc() const;
    void setYBloc(int value);

    void init(Action* parent);

    void addConnectorToFather(Connector * con);
    void addConnectorToTimeOut(Connector * con);

    bool addGirlToFather(EditableAction* fille);
    bool addGirlToTimeout(EditableAction * fille);
    void addFatherToGirl(EditableAction * pere);

    bool addGirlToFatherForExport(EditableAction* fille);
    bool addGirlToTimeoutForExport(EditableAction * fille);

    void moveConnectorFather(int x, int y);
    void moveConnectorTimeout(int x, int y);

    int getXFather() const;
    void setXFather(int value);

    int getYFather() const;
    void setYFather(int value);

    int getXTimeOut() const;
    void setXTimeOut(int value);

    int getYTimeOut() const;
    void setYTimeOut(int value);

    int getXEntree() const;
    void setXEntree(int value);

    int getYEntree() const;
    void setYEntree(int value);

signals:
    void xBlocChanged();
    void yBlocChanged();

    void xFatherChanged();
    void yFatherChanged();
    void xTimeoutChanged();
    void yTimeoutChanged();
    void xEntreeChanged();
    void yEntreeChanged();

    void eraseAFather();
    void eraseATimeout();

private:
    int xBloc;
    int yBloc;

    int xFather;
    int yFather;

    int xTimeOut;
    int yTimeOut;

    int xEntree;
    int yEntree;



    QList<EditableAction *> listPere;
    QList<EditableAction *> listFille;
    QList<EditableAction *> listTimeOut;

    QList<Connector* > listConnectorPere;
    QList<Connector* > listConnectorTimeout;


    QList<int> listIndiceFille;
    QList<int> listIndiceTimeout;
};

#endif // EDITABLEACTION_H
