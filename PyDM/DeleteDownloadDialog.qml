import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.10
import QtQuick.Dialogs 1.3
import 'qrc:///'
Window{
    id:cont
    width: 600
    height: 150
    minimumWidth: 600
    maximumHeight: 200
    maximumWidth: minimumWidth
    minimumHeight: maximumHeight
    visible: false
    flags:Qt.FramelessWindowHint
    property var range: false
    signal listAccepted()
    signal diskAccepted()
    signal rejected()
    function close_dialog(){
        err.visible = false
        cont.visible = false
    }





    Rectangle{
        id: cont_rect
        anchors.fill: parent
        color: '#28292c'
        border.width: 0.5
        border.color: '#cbcbcf'
        GridLayout{
            anchors.fill:parent
            columns: 2
            Rectangle{
                Layout.fillWidth: true
                Layout.preferredHeight:  30
                color: "#17171b"
                Layout.margins: 2
                Layout.alignment: Qt.AlignTop
                Layout.columnSpan: 2
                RowLayout{
                    anchors.fill: parent
                    Text{
                        Layout.fillWidth: true
                        Layout.leftMargin: 7
                        text:"Delete Process"
                        color: cont_rect.border.color
                        clip:true

                    }
                    CustomButton{
                        id:close
                        Layout.preferredWidth: 30
                        Layout.preferredHeight: 30
                        image_source: "qrc:///xicon.png"
                        image_fillMode: Image.PreserveAspectFit
                        radius: 0
                        color: "#171313"
                        padding: 8
                        onClicked: {
                            cont.rejected()
                            cont.close_dialog()
                        }
                    }
                }
            }
            Text{
                text: cont.range?"How do you want to delete the selected processes?":"How do you want to delete the process?"
                font.pixelSize: 16
                color: cont_rect.border.color
                Layout.preferredWidth: 50
                Layout.leftMargin: 7
                Layout.columnSpan: 2
                Layout.alignment: Qt.AlignTop
            }
            Text{
                id:err
                text: "Only tasks that are completed can be removed from list (Try deleting from disk)"
                visible: false
                font.pixelSize: 16
                color: "#fb3737"
                Layout.preferredWidth: 50
                Layout.leftMargin: 7
                Layout.columnSpan: 2
                Layout.alignment: Qt.AlignVCenter
            }
            RowLayout{
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                spacing: 7
                CustomButton{
                    color: "#1c1a1a"
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 35
                    Layout.leftMargin:  7
                    radius: 8
                    border.color: "#531b1b"
                    Text{
                        color: "#cfc9c9"
                        anchors.centerIn: parent
                        text: "Delete From Disk (Be Carefull!)"
                    }
                    onClicked:{
                        cont.diskAccepted()
                        cont.close_dialog()
                    }
                }
                CustomButton{
                    color: "#1c1a1a"
                    Layout.preferredWidth: 105
                    Layout.preferredHeight: 35
                    Layout.leftMargin:  0
                    Layout.alignment: Qt.AlignLeft
                    radius: 8
                    border.color: "#531b1b"
                    Text{
                        anchors.centerIn: parent
                        text: "Delete From List"
                        color: "#cfc9c9"
                    }
                    onClicked:{
                        if(!range && download_list.current_dict().status != "Completed"){
                            err.visible = true
                        }else{
                            cont.listAccepted()
                            cont.close_dialog()
                        }
                    }
                }
            }
        }
    }
}
