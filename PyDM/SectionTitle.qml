import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import 'qrc:///'
Item{
    id:cont
    //width: 1240
    //height: 50
    property var text: "Test"
    property var text_color: "white"
    property var text_size: 16
    property var divider_color: "gray"
    property var divider_thickness: 0.2
    property var divider_padding: 7
    property var spacing: 5
    ColumnLayout{
        anchors.fill:parent
        spacing: cont.spacing
        Text{
            font.pixelSize: cont.text_size
            color: cont.text_color
            text: cont.text
            Layout.fillWidth: true
            leftPadding: 5
        }
        Rectangle{
            color: cont.divider_color
            Layout.fillWidth: true
            Layout.preferredHeight: cont.divider_thickness
            Layout.bottomMargin: 2
            Layout.leftMargin: cont.divider_padding
            Layout.rightMargin: cont.divider_padding
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
