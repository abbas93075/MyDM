import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.10
import QtQuick.Dialogs 1.3
import 'qrc:///'
TabButton{
    id:cont
    text:"abbas" ;
    width: 70 ;
    property var selected: tb.currentIndex==TabBar.index
    contentItem: Text{
        text: cont.text
        font.pixelSize: 16
        //width: cont.width
        anchors.horizontalCenter: cont.horizontalCenter
        horizontalAlignment: Qt.AlignHCenter
        color: cont.selected?"white":"#6e6b63"
    }
    background: TabButtonStyle{selected:cont.selected}
}
