import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.10
import QtQuick.Dialogs 1.3
import 'qrc:///'
Window{
    width: 500
    height:150
    visible: false
    flags: Qt.FramelessWindowHint
    Rectangle{
        anchors.fill:parent
        color: '#28292c'       
        ColumnLayout{
            anchors.fill:parent
            Text{
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                Layout.leftMargin: 7
                font.pixelSize: 16
                color: '#cbcbcf'
                text: "The nb of current tasks exceeds the allowed limit(100) please remove existing tasks so you can add new ones"
                Layout.alignment: Qt.AlignHCenter
            }
            CustomButton{
                color: "#1c1a1a"
                Layout.preferredWidth: 75
                Layout.preferredHeight: 35
                //Layout.leftMargin:  7
                Layout.alignment: Qt.AlignHCenter
                radius: 8
                border.color: "#531b1b"
                Text{
                    anchors.centerIn: parent
                    text: "OK"
                    color: "#cfc9c9"
                }
                onClicked:{
                    close()
                }
            }
        }
    }
}
