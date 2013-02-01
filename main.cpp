//cutewiki is wikipedia reader for symbian and meego platforms
//Copyright (C) 2010 Krishna Somisetty

//This program is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.

//cutewiki is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.

//You should have received a copy of the GNU General Public License
//along with this program.  If not, see <http://www.gnu.org/licenses/>.

#include "smartboxhandler.h"

#include <QtGui/QApplication>
#include <QDeclarativeView>
#include <QDeclarativeContext>
#include <QDesktopWidget>
#include <QtCore>

#include "model.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QDesktopWidget* desktopWidget = QApplication::desktop();
    QRect clientRect = desktopWidget->screenGeometry();
    QDeclarativeView view;
    Model m;
    view.rootContext()->setContextProperty("appModel", &m);
    view.setSource(QUrl("qrc:/ui.qml"));
    view.setSceneRect(clientRect);
    view.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    view.showFullScreen();

    QObject::connect((QObject*)view.engine(), SIGNAL(quit()), &app, SLOT(quit()));
    QObject::connect(&m, SIGNAL(urlChanged()),(QObject*) view.rootObject(), SLOT(newurl()));
    view.show();

    return app.exec();
}
