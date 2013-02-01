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

import QtQuick 1.0
import com.nokia.meego 1.0
import QtWebKit 1.0

PageStackWindow {
    initialPage: mainPage

    Page{
        id: mainPage
        orientationLock: PageOrientation.LockPortrait
            Rectangle {
                id: mother
                width: 480
                height: 820
                color: "black"               

                Item {
                    id: mainp
                    anchors.fill: parent
                    visible: true

                    TextField {
                        id: searchbar
                        anchors.topMargin: 10
                        anchors.top: parent.top
                        anchors.left: parent.left
                        width: parent.width * 0.8
                        height: 50
                        clip: false
                        placeholderText : "Search Wikipedia"
                        onFocusChanged: {
                            if(focus)
                                openSoftwareInputPanel();
                        }

                        onTextChanged: {
                            appModel.setSearchString(text);
                        }
                    }

                    Button {
                        id: langicon
                        width: parent.width * 0.2
                        height: searchbar.height * 0.75
                        anchors.left: searchbar.right
                        anchors.top: parent.top
                        anchors.verticalCenter: searchbar.verticalCenter
                        text: selectionDialog.model.get(appModel.p_language).name
                        onClicked: {
                            selectionDialog.open();
                        }
                    }

                    SelectionDialog {
                        id: selectionDialog
                        titleText: "Select your language"
                        model: ListModel {
                            ListElement { name: "English";  value: "0";}
                            ListElement { name: "Catala";   value: "1";}
                            ListElement { name: "Cesky";    value: "2";}
                            ListElement { name: "Dansk";    value: "3";}
                            ListElement { name: "Deutsch";  value: "4";}
                            ListElement { name: "Espanol";  value: "5";}
                            ListElement { name: "Francais"; value: "6";}
                            ListElement { name: "Italiano"; value: "7";}
                            ListElement { name: "Magyar";   value: "8";}
                            ListElement { name: "Nederlands"; value: "9";}
                            ListElement { name: "Norsk";    value: "10";}
                            ListElement { name: "Portugues";value: "11";}
                            ListElement { name: "Polski";   value: "12";}
                            ListElement { name: "Suomi";    value: "13";}
                            ListElement { name: "Svenska";  value: "14";}
                            ListElement { name: "Russian";  value: "15";}
                        }

                        onRejected: {
                            searchbar.focus = true;
                        }

                        onAccepted: {
                            appModel.p_language = selectedIndex
                            langicon.text = selectionDialog.model.get(appModel.p_language).name
                            searchbar.focus = true;
                        }
                    }

                    Image {
                        id: busyicon
                        anchors.right: searchbar.right
                        anchors.rightMargin: 8
                        anchors.verticalCenter: searchbar.verticalCenter
                        source: "progress.png"
                        width: 30
                        height: 30
                        visible: appModel.p_busy ? true : false
                        PropertyAnimation on rotation { to: 360; duration: 1000; loops: Animation.Infinite}
                        }

                    onVisibleChanged: {
                        if(visible)
                            searchbar.focus = true;
                        }

                    ListView {
                        id: results
                        anchors.topMargin: 10
                        anchors.top: searchbar.bottom
                        width: parent.width
                        height: 400
                        model: appModel
                        delegate: Component {
                            Rectangle {
                                color: stringMA.pressed ? "#0d6bb0": "#00ffffff"
                                width: parent.width * 0.99
                                height: 50
                                radius: 4

                                Text {
                                    id: resultstitle
                                    color: "white";
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    font.pixelSize: 25
                                    text: title
                                    width: parent.width
                                    elide: Text.ElideRight;
                                    verticalAlignment: Text.AlignVCenter
                                    }

                                MouseArea {
                                    id: stringMA
                                    anchors.fill: parent
                                    onReleased: {
                                        if(title == "Search in Google.com")
                                            {
                                            appModel.searchInternet(searchbar.text);
                                            }
                                        else
                                            {
                                            appModel.showArticle(title);
                                            }
                                        }
                                    }
                                }
                        }
                    }
                }

                Flickable {
                    id: webitemflickable
                    anchors.fill: parent
                    visible: false
                    pressDelay: 200

                    contentWidth: webitem.width
                    contentHeight: webitem.height

                    WebView {
                        id: webitem
                        preferredWidth: mother.width
                        preferredHeight: mother.height
                        settings.defaultFontSize: appModel.p_fontsize;
                        //anchors.fill: parent
                        url: ""
                        z: 1
                        onLoadStarted: {
                            loader.visible = true
                        }

                        onLoadFinished: {
                            loader.visible = false
                        }

                        onLoadFailed: {
                            loader.visible = false
                        }
                    }
                }

                BusyIndicator {
                    id: loader
                    anchors.centerIn: parent
                    width: 75
                    height: 75
                    running: true
                    }

                Item {
                    id: zoominout
                    width: 55
                    height: zoomin.height + zoomout.height
                    visible: webitemflickable.visible ? true : false
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    z: 2
                    opacity: 0.3

                    Image {
                        id: zoomin
                        smooth: true
                        anchors.margins: 1
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: "zoomin.png"
                        width: 50
                        height: 65
                        scale: zoominMA.pressed ? 0.9 : 1.0

                        onScaleChanged: {
                            if(scale == 1.0)
                                {
                                if(webitem.settings.defaultFontSize <35)
                                    {
                                    var f = webitem.settings.defaultFontSize;
                                    f+=3;
                                    appModel.p_fontsize = f;
                                    }
                                }
                        }

                        MouseArea {
                            id: zoominMA
                            anchors.fill: parent
                            }
                        }

                    Image {
                        id: zoomout
                        smooth: true
                        anchors.margins: 1
                        anchors.top: zoomin.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: "zoomout.png"
                        width: 50
                        height: 65
                        scale: zoomoutMA.pressed ? 0.9 : 1.0

                        onScaleChanged: {
                            if(scale == 1.0)
                                {
                                if(webitem.settings.defaultFontSize > 8)
                                    {
                                    var f = webitem.settings.defaultFontSize;
                                    f-=3;
                                    appModel.p_fontsize = f;
                                    }
                                }
                            }

                        MouseArea {
                            id: zoomoutMA
                            anchors.fill: parent
                            }
                        }
                    }

                Rectangle {
                    id: wikipagetoolbar
                    z: 2
                    color: "#AA4d4d4d"
                    height: 75
                    width: parent.width;
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    visible: webitemflickable.visible

                    Row {
                        id: roww
                        anchors.fill: parent

                        Rectangle {
                           color: menuMA1.pressed ? "#0d6bb0" : "#00ffffff"
                           radius: 4
                           anchors.margins: 3
                           width: (parent.width)/ 4
                           height: parent.height * 0.9;

                           Image {
                               smooth: true
                               anchors.centerIn: parent
                               width: 40
                                height: 40
                                source: "home.png"
                               }

                           MouseArea {
                               id: menuMA1
                               anchors.fill: parent

                               onReleased: {
                                   mainp.visible = true;
                                   webitemflickable.visible = false
                                   webitem.url = ""
                                }
                            }
                        }

                        Rectangle {
                           color: menuMA2.pressed ? "#0d6bb0" : "#00ffffff"
                           radius: 4
                           anchors.margins: 3
                           width: (parent.width)/ 4
                           height: parent.height * 0.9;

                           Image {
                               smooth: true
                               anchors.centerIn: parent
                               width: 40
                                height: 40
                                source: "back.png"
                               }

                           MouseArea {
                               id: menuMA2
                               anchors.fill: parent
                               onReleased: {
                                   webitem.back.trigger();
                                    }
                                }
                            }

                        Rectangle {
                           color: menuMA3.pressed ? "#0d6bb0" : "#00ffffff"
                           radius: 4
                           anchors.margins: 3
                           width: (parent.width)/ 4
                           height: parent.height * 0.9;

                           Image {
                               smooth: true
                               anchors.centerIn: parent
                               width: 40
                                height: 40
                                source: "next.png"
                               }

                           MouseArea {
                               id: menuMA3
                               anchors.fill: parent

                               onReleased: {
                                    webitem.forward.trigger();
                                    }
                                }
                            }

                        Rectangle {
                           color: menuMA5.pressed ? "#0d6bb0" : "#00ffffff"
                           radius: 4
                           anchors.margins: 3
                           width: (parent.width)/ 4
                           height: parent.height * 0.9;

                           Image {
                               smooth: true
                               anchors.centerIn: parent
                               width: (parent.width) ? 40 : 0
                                height: (parent.width) ? 40 : 0
                                source: "email.png"
                               }

                           MouseArea {
                               id: menuMA5
                               anchors.fill: parent

                               onReleased: { appModel.shareArticle(webitem.url); }
                                }
                            }
                    }
                }
            }
    }

    function newurl()
    {
        console.log("newurl >>");
        webitem.url = appModel.p_url
        webitemflickable.visible = true;
        mainp.visible = false;
        console.log("newurl <<");
    }
}
