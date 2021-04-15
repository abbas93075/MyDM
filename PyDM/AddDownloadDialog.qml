import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.10
import QtQuick.Dialogs 1.3
import 'qrc:///'
Window{
    id:cont
    width: 600
    height: 200
    minimumWidth: 600
    maximumHeight: 200
    maximumWidth: minimumWidth
    minimumHeight: maximumHeight
    visible: false
    property var validUrl: false
    property var url: ""
    property var defaultpath: "C:\\Users\\Abbas\\Desktop\\idmtst"
    flags:Qt.FramelessWindowHint
    signal accepted()
    signal rejected()
    function reset(){
        cont.url=""
        cont.validUrl=false
        cont.defaultpath = "C:\\Users\\Abbas\\Desktop\\idmtst"
    }
    onVisibleChanged: {
        if(visible){
            //take link from clip
            error.visible = false
            filedownloader.request_clipboard_link()
        }
    }
    function show(){
        this.visible = true
    }
    FileDialog{
        id: destination_picker
        title: "Pick a destination"
        selectFolder: true
        onAccepted: cont.defaultpath = fileUrl.toString().replace("file:///","")

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

            Text{
                text: "URL"
                font.pixelSize: 16
                color: cont_rect.border.color
                Layout.preferredWidth: 50
                Layout.leftMargin: 7
            }
            Rectangle{
                Layout.fillWidth: true
                Layout.preferredHeight:  30
                color: "#232324"
                border.width: 0.5
                border.color: "#74747e"
                Layout.rightMargin: 7
                TextInput{
                    id:url
                    anchors{
                        verticalCenter: parent.verticalCenter

                        left:parent.left
                        right:parent.right
                        leftMargin: 7
                        rightMargin: 7
                    }
                    text:cont.url
                    width:parent.width
                    color: cont_rect.border.color
                    clip:true
                    selectionColor:"#531b1b"
                    onTextChanged: cont.url = text

                }
            }
            Text{
                text: "Path"
                font.pixelSize: 16
                color: cont_rect.border.color
                Layout.preferredWidth: 55
                Layout.leftMargin: 7
            }
            Rectangle{
                Layout.fillWidth: true
                Layout.preferredHeight:  30
                color: "#232324"
                border.width: 0.5
                border.color: "#74747e"
                Layout.rightMargin: 7
                RowLayout{
                    anchors.fill: parent
                    TextInput{
                        id:path
                        Layout.margins: 0.5
                        Layout.leftMargin: 7
                        Layout.fillWidth: true
                        color: cont_rect.border.color
                        clip:true
                        text: cont.defaultpath
                        selectionColor:"#531b1b"
                    }
                    CustomButton{

                        color: "#1c1a1a"
                        image_source: "qrc:///3d.png"
                        image_fillMode: Image.PreserveAspectFit
                        Layout.margins:2
                        Layout.preferredHeight: 25
                        Layout.preferredWidth: 40
                        onClicked: destination_picker.open()

                    }
                }
            }

            Text{
                id:error
                color: "#fb3737"
                font.pixelSize: 16
                text: "Please Enter A Valid Download Link"
                Layout.columnSpan: 2
                Layout.leftMargin: 7
                visible: false
            }

            CustomButton{
                color: "#1c1a1a"
                Layout.preferredWidth: 75
                Layout.preferredHeight: 35
                Layout.leftMargin:  7
                radius: 8
                border.color: "#531b1b"
                Text{
                    color: "#cfc9c9"
                    anchors.centerIn: parent
                    text: "Confirm"
                }
                onClicked:{
                    filedownloader.check_link(cont.url)
                    if(cont.validUrl){
                        cont.accepted()
                        cont.reset()
                        cont.close()
                    }else{
                        error.visible = true
                    }
                }
            }
            CustomButton{
                color: "#1c1a1a"
                Layout.preferredWidth: 75
                Layout.preferredHeight: 35
                Layout.leftMargin:  7
                radius: 8
                border.color: "#531b1b"
                Text{
                    anchors.centerIn: parent
                    text: "Cancel"
                    color: "#cfc9c9"
                }
                onClicked:{
                    cont.rejected()
                    cont.reset()
                    cont.close()
                }
            }
        }
    }
}
