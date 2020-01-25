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
#include "EditionStrategie/etape.h"
#include "EditionStrategie/gestionetape.h"
#include <QQmlContext>

int main(int argc, char *argv[])
{
    // Qt Charts uses Qt Graphics View Framework for drawing, therefore QApplication must be used.
    QApplication app(argc, argv);
    GestionRoboclaw roboclaw;
    GestionEtape gestEtape;
    QQuickView viewer;

    // The following are needed to make examples run without having to install the module
    // in desktop environments.

    QString extraImportPath(QStringLiteral("%1/../../../%2"));

    viewer.engine()->addImportPath(extraImportPath.arg(QGuiApplication::applicationDirPath(),
                                                       QString::fromLatin1("qml")));
    QObject::connect(viewer.engine(), &QQmlEngine::quit, &viewer, &QWindow::close);

    qmlRegisterType<Etape>("etape", 1, 0, "Etape");

    viewer.setTitle(QStringLiteral("Creator Durian"));
    viewer.engine()->rootContext()->setContextProperty("gestRoboclaw", &roboclaw);
    viewer.engine()->rootContext()->setContextProperty("gestEtape", &gestEtape);
    viewer.engine()->rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());
    viewer.setSource(QUrl("qrc:/main.qml"));
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.show();

    roboclaw.init();

    return app.exec();
}
