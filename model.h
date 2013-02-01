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

#ifndef MODEL_H
#define MODEL_H

#include <QtCore>
#include<QTimer>
#include <QAbstractItemModel>

#include "smartboxhandler.h"
#include "config.h"

class HistoryModel;
class FavModel;

class Model: public QAbstractListModel {
    Q_OBJECT

    Q_PROPERTY(  QString p_url
                 READ url
                 WRITE seturl
                 NOTIFY urlChanged)

    Q_PROPERTY(  bool p_busy
                 READ busy
                 WRITE setbusy
                 NOTIFY busyChanged)

    Q_PROPERTY(  QString p_error
                 READ error
                 WRITE seterror
                 NOTIFY errorChanged)

    Q_PROPERTY(  int p_fontsize
                 READ fontsize
                 WRITE setfontsize
                 NOTIFY fontsizeChanged)

    Q_PROPERTY(  int p_language
                 READ language
                 WRITE setlanguage
                 NOTIFY languageChanged)

public:
    Model();
    ~Model();

    virtual int rowCount(const QModelIndex& index ) const;
    virtual QVariant data(const QModelIndex& index, int role ) const;

    int language() {
        return m_language;
        }

    void setlanguage(int lang)
        {
        LS(lang);
        m_language = lang;
        m_urlprefix = languageToStr();
        m_dbhandler->seturlprefix(m_urlprefix);

        //clear the history so that previous language results are not stored.
        if(m_resultsmap)
            m_resultsmap->clear();

        emit languageChanged();
        }

    QString url() {return m_url;}
    void seturl(QString url)
        {
        m_url = url;
        emit urlChanged();
        }
    
    QString languageToStr();

    bool busy() {return m_busy;}

    void setbusy(bool state) {
        m_busy = state;
        emit busyChanged();
        }

    void seterror(const QString msg) {
        m_error = msg;
        emit errorChanged();
    }

    int fontsize() {
        return m_fontsize;
    }

    void setfontsize(int fontsize)
        {
        m_fontsize = fontsize;
        emit fontsizeChanged();
        }

    QString error() {return m_error;}

    Q_INVOKABLE int setSearchString(const QString& searchString);
    Q_INVOKABLE void showArticle(const QString& title);
    Q_INVOKABLE void searchInternet(const QString& str);
    Q_INVOKABLE void shareArticle(const QString& url);
signals:

    void urlChanged();
    void canQuit();
    void busyChanged();
    void errorChanged();
    void fontsizeChanged();
    void languageChanged();

public slots:
    void HandleSearchComplete(const QString& searchString, QStringList, int nwerror, bool cachedresults = false);

private:
    SmartboxHandler* m_dbhandler;
    QStringList m_searchresults;
    QVariantMap* m_resultsmap;
    QString m_searchString;
    QString m_url;
    QString m_error;
    QString m_urlprefix;
    int m_fontsize;
    int m_language;
    bool m_busy;
};

#endif // MODEL_H
