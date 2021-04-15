import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3
import Qt.labs.platform 1.1
import 'qrc:///'
ApplicationWindow{
    id:mainwindow
    visible: true
    width: 1240
    height: 720
    minimumHeight: 720
    minimumWidth: 1240
    title:qsTr("My Download Manager")
    onClosing: {
        filedownloader.unfinished_check()
    }
    /*onWindowStateChanged: {
        if(windowState == Qt.WindowMinimized)
            hide()
    }*/
    Loader{
        anchors.fill: parent
        id:ploader
        source: "MainPage.qml"
        focus: true
    }
    //Component.onDestruction: filedownloader.wrap_up()
    SystemTrayIcon {
        visible: true
        icon.source: "qrc:///mi.png"

        onActivated: {
            mainwindow.show()
            mainwindow.raise()

        }
    }
    Connections{
        target: filedownloader
        onUnfinished_check_returned:{
            if(unfinished_check){
                if(mainwindow.visible)
                    ynd.show()
                //allow_close = false*/
                mainwindow.hide()
            }else{
                filedownloader.wrap_up()
                Qt.quit()
            }
        }
    }


}
