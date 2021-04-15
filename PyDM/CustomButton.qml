import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import 'qrc:///'
Rectangle{
    id:container
    width:50
    height:50
    color: "white"
    radius: (this.width == this.height)?this.width/2:0
    property var image_source:"file"
    property var image_fillMode: Image.Stretch
    property var padding:0
    property var cursorShape:Qt.ArrowCursor
    property var triggerButtons: Qt.LeftButton
    property var propagateMouseEvents: false
    property var mouseX : ma.mouseX
    property var mouseY: ma.mouseY
    signal clicked()
    signal hold()
    signal mouseEntered()
    signal mouseExited()
    signal released()
    function click(){
        ma.clicked()
    }
    Image{
        anchors{
            fill:parent
            left:parent.left
            right:parent.right
            top:parent.top
            bottom:parent.bottom
            margins: container.padding
        }
        fillMode: container.image_fillMode
        source:container.image_source
        sourceSize.width: container.width
        sourceSize.height: container.height
    }
    MouseArea{
        id:ma
        focus: true
        anchors.fill:parent
        acceptedButtons: container.triggerButtons
        onClicked: container.clicked()
        onEntered: container.mouseEntered()
        onExited: container.mouseExited()
        onPressAndHold: container.hold()
        onReleased: container.released()
        hoverEnabled: true
        propagateComposedEvents: container.propagateMouseEvents
        cursorShape: container.cursorShape
    }
}
