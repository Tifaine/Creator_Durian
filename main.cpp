/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Charts module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include <QtWidgets/QApplication>
#include <QtQuick/QQuickView>
#include <QtCore/QDir>
#include <QtQml/QQmlEngine>
#include "ControleRoboclaw/gestionroboclaw.h"
#include "ControleDyna/gestiondynamixel.h"
#include "ControleDyna/dyna.h"
#include "EditionStrategie/etape.h"
#include "EditionStrategie/position.h"
#include "EditionStrategie/itemtaux.h"
#include "EditionStrategie/gestionetape.h"
#include "EditionStrategie/gestionstrategie.h"
#include "EditionSequence/action.h"
#include "EditionSequence/editableaction.h"
#include "EditionSequence/gestionaction.h"
#include "EditionSequence/gestionsequence.h"
#include "EditionSequence/Components/connector.h"
#include "Simulation/gestionsimulation.h"
#include <QQmlContext>
#include "mqttclient.h"

void initRep();

int main(int argc, char *argv[])
{
    // Qt Charts uses Qt Graphics View Framework for drawing, therefore QApplication must be used.
    QApplication app(argc, argv);
    app.setOrganizationName("RCO");
    app.setOrganizationDomain("RCO");
    initRep();
    GestionRoboclaw roboclaw;
    GestionEtape gestEtape;
    GestionStrategie gestStrat;
    GestionAction gestAction;
    QQuickView viewer;
    mqttClient client;
    GestionDynamixel dynamixel(&client);
    GestionSimulation gestSimu;

    // The following are needed to make examples run without having to install the module
    // in desktop environments.

    QString extraImportPath(QStringLiteral("%1/../../../%2"));

    viewer.engine()->addImportPath(extraImportPath.arg(QGuiApplication::applicationDirPath(),
                                                       QString::fromLatin1("qml")));
    QObject::connect(viewer.engine(), &QQmlEngine::quit, &viewer, &QWindow::close);

    qmlRegisterType<Etape>("etape", 1, 0, "Etape");
    qmlRegisterType<Position>("position", 1, 0, "Position");
    qmlRegisterType<Action>("action", 1, 0, "Action");
    qmlRegisterType<EditableAction>("editableAction", 1, 0, "EditableAction");
    qmlRegisterType<Connector>("connector", 1, 0, "Connector");
    qmlRegisterType<GestionSequence>("gestionSequence", 1, 0, "GestionSequence");
    qmlRegisterType<Dyna>("dyna", 1, 0, "Dyna");

    viewer.setTitle(QStringLiteral("Creator Durian"));
    viewer.engine()->rootContext()->setContextProperty("gestRoboclaw", &roboclaw);
    viewer.engine()->rootContext()->setContextProperty("gestDynamixel", &dynamixel);
    viewer.engine()->rootContext()->setContextProperty("gestEtape", &gestEtape);
    viewer.engine()->rootContext()->setContextProperty("gestStrat", &gestStrat);
    viewer.engine()->rootContext()->setContextProperty("gestAction", &gestAction);
    viewer.engine()->rootContext()->setContextProperty("gestSimu", &gestSimu);

#ifdef Q_OS_LINUX
    viewer.engine()->rootContext()->setContextProperty("fileRoot", "file://");

#elif defined(Q_OS_WIN)
    viewer.engine()->rootContext()->setContextProperty("fileRoot", "file:///");

#endif
    viewer.engine()->rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());

    viewer.setSource(QUrl("qrc:/main.qml"));
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.show();

    roboclaw.init();

    return app.exec();
}

void initRep()
{
    if( ! QDir("data").exists())
    {
        QDir().mkdir("data");
        QDir().mkdir("data/Dyna");
        QDir().mkdir("data/Etape");
        QDir().mkdir("data/Sequence");
        QDir().mkdir("data/Sequence/Action");
        QDir().mkdir("data/Strategie");
    }else
    {
        if( ! QDir("data/Dyna").exists())
        {
            QDir().mkdir("data/Dyna");
        }
        if( ! QDir("data/Etape").exists())
        {
            QDir().mkdir("data/Etape");
        }
        if( ! QDir("data/Sequence").exists())
        {
            QDir().mkdir("data/Sequence");
            QDir().mkdir("data/Sequence/Action");
        }
        if( ! QDir("data/Sequence/Action").exists())
        {
            QDir().mkdir("data/Sequence/Action");
        }
        if( ! QDir("data/Strategie").exists())
        {
            QDir().mkdir("data/Strategie");
        }
    }
}
