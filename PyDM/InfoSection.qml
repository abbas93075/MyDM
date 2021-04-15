import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3
import 'qrc:///'
Rectangle{
    id:cont
    property var up:false
    property var info
    color: "transparent"
    ColumnLayout{

        anchors.fill:parent
        spacing: 0
        //anchors.bottom: parent.bottom
        anchors.verticalCenter: parent.verticalCenter

        Rectangle{
            id: head
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            color: "#1c1a1a"
            Layout.alignment: Qt.AlignBottom
            RowLayout{
                anchors.fill: parent
                Text{

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    elide: Text.ElideRight
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: 18
                    leftPadding: 7
                    color: "#cfc9c9"
                    text: cont.info[0] //name
                }
                CustomButton{
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: 20
                    image_source: (cont.up)?"qrc:///info_down.png":"qrc:///info_up.png"
                    image_fillMode: Image.PreserveAspectFit
                    Layout.rightMargin: 7
                    color: "transparent"
                    onClicked:{
                        cont.up = !cont.up
                        if(cont.up)
                            head.Layout.alignment = Qt.AlignTop
                        else
                            head.Layout.alignment = Qt.AlignBottom
                    }
                }
            }
        }
        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            //visible: cont.up
            visible: true
            GridLayout{
                anchors.fill: parent
                anchors.top: head.bottom
                anchors.topMargin: 7
                columns: 2
                columnSpacing: 0
                rowSpacing: 0
                property var color: "#cfc9c9"
                Text{
                    Layout.preferredWidth: 75
                    Layout.preferredHeight: 30
                    leftPadding: 7
                    font.pixelSize: 16
                    horizontalAlignment: Qt.AlignLeft
                    text: "Status:"
                    color: parent.color
                }
                Text{
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Layout.preferredHeight: 30
                    leftPadding: 7
                    font.pixelSize: 16
                    horizontalAlignment: Qt.AlignLeft
                    text: cont.info[1] //stat
                    color: parent.color
                }
                Text{
                    Layout.preferredWidth: 75
                    Layout.preferredHeight: 30
                    leftPadding: 7
                    font.pixelSize: 16
                    horizontalAlignment: Qt.AlignLeft
                    text: "Size: "
                    color: parent.color
                }
                Text{
                    elide: Text.ElideRight
                    Layout.preferredWidth: 75
                    Layout.preferredHeight: 30
                    Layout.fillWidth: true
                    leftPadding: 7
                    font.pixelSize: 16
                    horizontalAlignment: Qt.AlignLeft
                    text: cont.info[2] //size
                    color: parent.color
                }
                Text{
                    Layout.preferredWidth: 75
                    Layout.preferredHeight: 30
                    leftPadding: 7
                    font.pixelSize: 16
                    horizontalAlignment: Qt.AlignLeft
                    text: "Type: "
                    color: parent.color
                }
                Text{
                    elide: Text.ElideRight
                    Layout.preferredHeight: 30
                    Layout.fillWidth: true
                    leftPadding: 7
                    font.pixelSize: 16
                    horizontalAlignment: Qt.AlignLeft
                    text: cont.info[3] //type
                    color: parent.color
                }
                Text{
                    Layout.preferredWidth: 75
                    Layout.preferredHeight: 30
                    leftPadding: 7
                    font.pixelSize: 16
                    horizontalAlignment: Qt.AlignLeft
                    text: "Location: "
                    color: parent.color
                }
                Text{
                    elide: Text.ElideRight
                    Layout.preferredHeight: 30
                    Layout.fillWidth: true
                    leftPadding: 7
                    font.pixelSize: 16
                    horizontalAlignment: Qt.AlignLeft
                    text: cont.info[4] //loc
                    color: parent.color
                }
                Text{
                    Layout.preferredWidth: 75
                    Layout.preferredHeight: 30
                    leftPadding: 7
                    font.pixelSize: 16
                    horizontalAlignment: Qt.AlignLeft
                    text: "Added: "
                    color: parent.color
                }
                Text{
                    elide: Text.ElideRight
                    Layout.preferredHeight: 30
                    Layout.fillWidth: true
                    leftPadding: 7
                    font.pixelSize: 16
                    horizontalAlignment: Qt.AlignLeft
                    text: cont.info[5] //dat
                    color: parent.color
                }
                Text{
                    Layout.preferredWidth: 75
                    Layout.preferredHeight: 30
                    leftPadding: 7
                    font.pixelSize: 16
                    horizontalAlignment: Qt.AlignLeft
                    text: "Schedule: "
                    color: parent.color
                }
                Text{
                    elide: Text.ElideRight
                    Layout.preferredHeight: 30
                    Layout.fillWidth: true
                    leftPadding: 7
                    font.pixelSize: 16
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Qt.AlignLeft
                    text: cont.info[6] //url
                    color: parent.color
                }
            }
        }
    }
}








/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
