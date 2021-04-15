import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import 'qrc:///'
CustomButton{
    property var size: 20
    property var checked: isSelectedButton()
    property var group: null
    property var gid: -1
    signal check()
    function isSelectedButton(){
        return group.selected_button == this
    }
    width:size
    height: size
    radius: size/2
    border.color: "gray"
    color: "pink"
    Rectangle{
        color: parent.border.color
        radius: width/2
        visible: parent.checked
        anchors{
            fill: parent
            left: parent.left
            top:parent.top
            right: parent.right
            bottom: parent.bottom
            margins: 3
        }
    }
    onClicked: {
        if(!checked)
            group.selected_button = this

    }
}
