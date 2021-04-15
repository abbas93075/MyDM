import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import 'qrc:///'
Rectangle{
    width:gv.cellWidth
    height: gv.cellHeight
    color: '#28292c'
    RowLayout{
        anchors.fill: parent
        DayCheckBox{
            Layout.preferredHeight: 20
            Layout.preferredWidth: 20
            Layout.leftMargin: 7
            checked: marked
        }

        Text{
            font.pixelSize: 16
            Layout.fillWidth: true
            color: '#cbcbcf'
            text:day
        }
    }
}
