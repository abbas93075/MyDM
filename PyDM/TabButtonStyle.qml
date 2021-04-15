import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import 'qrc:///'
Rectangle{
    //height: 40
    //color: "#161313"
    color: "#17171b"
    //width: 70
    property var selected: false

    Rectangle{
        width:parent.width
        height: 3
        color: parent.selected?"red":"white"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 7
        anchors.right: parent.right
        anchors.rightMargin: 7
        radius: 8
        visible: selected
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
