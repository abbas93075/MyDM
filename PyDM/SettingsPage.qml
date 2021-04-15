import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3
import 'qrc:///'
Rectangle{
    id:cont
    anchors.fill: parent
    color: "#28292c"
    Component.onCompleted: {
        sm.request_settings()
    }
    Component.onDestruction: sm.save()
    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        Rectangle{
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: "#17171b"
            CustomButton{
                color: "transparent"
                anchors.left: parent.left
                anchors.leftMargin: 7
                height: 40
                width: 40
                image_source: "qrc:///back_arrow.png"
                onClicked: ploader.source = "MainPage.qml"
            }
        }
        TabBar{
            id:tb
            //Layout.fillWidth: true
            spacing: 0
            background: Rectangle{color:"transparent"}
            CustomTabButton{text:"Network"; width:cont.width/2}
            CustomTabButton{text:"System"; width:cont.width/2}
        }
        Item {
            id:tabs
            Layout.fillWidth: true
            Layout.fillHeight: true
            StackLayout{
                anchors.fill:parent
                currentIndex: tb.currentIndex
                NetworkTab{id:nt ; anchors.fill: parent}
                SystemTab{id:st ;anchors.fill: parent}
                //Rectangle{anchors.fill: parent;color: "blue"}
            }
        }


    }
    Connections{
        target: sm
        onSettings_returned: {
            nt.netSet_model = request_settings.Network
            st.osSetModel = request_settings.System          
        }
    }

}


/*##^##
Designer {
    D{i:0;autoSize:true;height:720;width:1240}
}
##^##*/
