#cutewiki is wikipedia reader for symbian and meego platforms
#Copyright (C) 2010 Krishna Somisetty

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#cutewiki is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.


#cusrule.pkg_prerules = \
#"%{\"Somisetty\"}"\
#" "\
#:\"Somisetty\""


SOURCES += main.cpp \
    smartboxhandler.cpp \
    model.cpp
HEADERS += smartboxhandler.h \
    model.h \
    config.h \
    config.h


# Please do not modify the following two lines. Required for deployment.
include(deployment.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    ui.qml


QT += declarative network xml

RESOURCES += \
    res.qrc


