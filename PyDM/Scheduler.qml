import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import 'qrc:///'
Rectangle{
    width: 600
    height: 180
    color:'#28292c'
    property var tf: time_from.t
    property var tt: time_to.t
    property var days: [false,false,false,false,false,false,false]
    ColumnLayout{
        anchors.fill: parent
        spacing: 15
        Item{
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            Layout.topMargin: 7
            RowLayout{
                anchors.fill: parent
                Text{
                    color: '#cbcbcf'
                    font.pixelSize: 16
                    Layout.preferredWidth: 50
                    //Layout.fillHeight: true
                    text: "From"
                    Layout.leftMargin: 7
                }
               TimeSelector{
                   id:time_from
                    Layout.preferredWidth: 200
                    Layout.fillHeight: true
                    color: "#1c1a1a"
                }
                Text{
                    color: '#cbcbcf'
                    font.pixelSize: 16
                    Layout.preferredWidth: 30
                    //Layout.fillHeight: true
                    text: "To"
                    Layout.leftMargin: 7
                }
                TimeSelector{
                    id:time_to
                    Layout.preferredWidth: 200
                    Layout.fillHeight: true
                    color: "#1c1a1a"
                }
            }
        }
        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
            ColumnLayout{
                anchors.fill: parent
                Text{
                    id:ad
                    font.pixelSize: 16
                    color:'#cbcbcf'
                    text: "Repeat"
                    anchors.left:parent.left
                    anchors.leftMargin: 7
                }
                GridView{
                    id:gv
                    Layout.fillHeight: true
                    Layout.fillWidth : true
                    cellHeight: 30
                    cellWidth: 170
                    function mark(i , bool_val){
                        days.splice(i,1,bool_val)
                    }
                    model:ListModel{
                        ListElement{day:"Monday" ; marked:false}
                        ListElement{day:"Tuesday" ; marked:false}
                        ListElement{day:"Wednesday" ; marked:false}
                        ListElement{day:"Thursday" ; marked:false}
                        ListElement{day:"Friday" ; marked:false}
                        ListElement{day:"Saturday" ; marked:false}
                        ListElement{day:"Sunday" ; marked:false}
                    }
                    delegate: CheckedDayDelegate{}
                }
            }
        }
    }

}
