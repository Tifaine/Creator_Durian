#ifndef CONNECTOR_H
#define CONNECTOR_H

#include <QObject>
#include <QString>
#include <QQuickItem>

class Connector : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(int x1 READ getX1 WRITE setX1 NOTIFY x1Changed)
       Q_PROPERTY(int y1 READ getY1 WRITE setY1 NOTIFY y1Changed)
       Q_PROPERTY(int x2 READ getX2 WRITE setX2 NOTIFY x2Changed)
       Q_PROPERTY(int y2 READ getY2 WRITE setY2 NOTIFY y2Changed)
       Q_PROPERTY(QString _color READ getColor WRITE setColor NOTIFY _colorChanged)
public:
    Connector(QQuickItem *parent = nullptr);

    QSGNode *updatePaintNode(QSGNode *, UpdatePaintNodeData *updatePaintNodeData);
    void mousePressEvent(QMouseEvent *event);

    int getX1();
    int getY1();

    int getX2();
    int getY2();

    void setX1(const int _x);
    void setY1(const int _y);
    void setX2(const int _x);
    void setY2(const int _y);
    QString getColor() const;
    void setColor(const QString &color);

signals:
    void x1Changed();
    void y1Changed();
    void x2Changed();
    void y2Changed();
    void _colorChanged();

public slots:

private:
    int x1=0;
    int y1=0;
    int x2=0;
    int y2=0;
    QString _color = "#FF007F";
    bool m_needUpdate;

};

#endif // CONNECTOR_H
