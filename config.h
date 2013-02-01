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

#ifndef CUTEWIKI_CONFIG
#define CUTEWIKI_CONFIG

#include <QtDebug>

#define DISABLE_LOGS
#define CONNECT_UPON_LAUNCH
#define USE_MOBILE_VERSION
#define FULL_TEXT_SEARCH


#ifdef DISABLE_LOGS
    #define LS(x)
#else
    #define LS(x) qDebug()<<x
#endif

#define CONFIGFILE "cw.config"
#define FONTSIZE 25
#endif //cuteWiki_CONFIG
