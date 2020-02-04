#include "connector.h"
#include <QtQuick/qsgnode.h>
#include <QtQuick/qsgflatcolormaterial.h>
#include <QtQuick/QSGGeometryNode>
#include <QSGMaterial>
#include <QSGMaterialShader>

Connector::Connector(QQuickItem *parent) : QQuickItem(parent)
{
    m_needUpdate = true;
    setAcceptedMouseButtons(Qt::AllButtons);
    setFlag(ItemHasContents, true);
    update();
}

int Connector::getX1()
{
    return x1;
}

int Connector::getY1()
{
    return y1;
}

void Connector::setX1(const int _x)
{
    x1 = _x;
    m_needUpdate = true;
    update();
    emit x1Changed();
}

void Connector::setY1(const int _y)
{
    y1 = _y;
    m_needUpdate = true;
    update();
    emit y1Changed();
}

int Connector::getX2()
{
    return x2;
}

int Connector::getY2()
{
    return y2;
}

void Connector::setX2(const int _x)
{
    x2 = _x;
    m_needUpdate = true;
    update();
    emit x2Changed();
}

void Connector::setY2(const int _y)
{
    y2 = _y;
    m_needUpdate = true;
    update();
    emit y2Changed();
}

QString Connector::getColor() const
{
    return _color;
}

void Connector::setColor(const QString &color)
{
    _color = color;
    m_needUpdate = true;
    update();
}

void Connector::mousePressEvent(QMouseEvent *event)
{
    event->ignore();
}

QSGNode *Connector::updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *updatePaintNodeData)
{
    Q_UNUSED(updatePaintNodeData)
    QSGGeometryNode *root = 0;
    if(!oldNode) {
        root = new QSGGeometryNode;
    }else
    {
        root = static_cast<QSGGeometryNode *>(oldNode);
    }

    QSGFlatColorMaterial *material = new QSGFlatColorMaterial;
    material->setColor(_color);
    material->setFlag(QSGMaterial::Blending, true);
    root->setMaterial(material);
    QSGGeometry *geometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), 2);
    geometry->setLineWidth(3);
    geometry->setDrawingMode(QSGGeometry::DrawLines);
    geometry->vertexDataAsPoint2D()[0].set(x1, y1);
    geometry->vertexDataAsPoint2D()[1].set(x2, y2);
    root->setGeometry(geometry);
    root->setFlag(QSGNode::OwnsGeometry);
    root->setFlag(QSGNode::OwnsMaterial);
    m_needUpdate = false;
    return root;
}
