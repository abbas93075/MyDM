import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.10
import QtQuick.Dialogs 1.3
import 'qrc:///'
Window{
    id:cont
    width: 600
    height: 250
    minimumWidth: 600
    maximumHeight: 300
    maximumWidth: minimumWidth
    minimumHeight: maximumHeight
    visible: false
    flags:Qt.FramelessWindowHint
    signal scheduleradded()
    signal schedulerRemoved()
    property var tf: time_from.t
    property var tt: time_to.t
    property var days: [false,false,false,false,false,false,false]




    Rectangle{
        id: cont_rect
        anchors.fill: parent
        color: '#28292c'
        border.width: 0
        //border.color: '#cbcbcf'
        ColumnLayout{
            anchors.fill:parent
            spacing: 0
            Rectangle{
                Layout.fillWidth: true
                Layout.preferredHeight:  30
                color: "#17171b"
                Layout.margins: 0
                Layout.alignment: Qt.AlignTop
                Layout.columnSpan: 2
                RowLayout{
                    anchors.fill: parent
                    Text{
                        Layout.fillWidth: true
                        Layout.leftMargin: 7
                        text:"Download Scheduler"
                        color: '#cbcbcf'
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
                            cont.close()
                        }
                    }
                }
            }
            Rectangle{
                width: 600
                height: 180
                color:'#28292c'
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
                                t:[0,0,0]
                                Layout.preferredWidth: 200
                                Layout.fillHeight: true
                                color: "#1c1a1a"
                                onTimeChanged: cont.tf = t
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
                                t:[23,59,59]
                                Layout.preferredWidth: 200
                                Layout.fillHeight: true
                                color: "#1c1a1a"
                                onTimeChanged: cont.tt = t
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

            RowLayout{
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                Layout.bottomMargin: 7
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
                        text: "Add Scheluler(Replace Exisitng)"
                    }
                    onClicked:{
                        cont.scheduleradded()
                        filedownloader.set_scheduler(download_list.currentIndex , cont.days , time_from.string_time() , time_to.string_time(),
                                                     main.search)
                        cont.close()
                    }
                }
                CustomButton{
                    color: "#1c1a1a"
                    Layout.preferredWidth: 175
                    Layout.preferredHeight: 35
                    Layout.leftMargin:  0
                    Layout.alignment: Qt.AlignLeft
                    radius: 8
                    border.color: "#531b1b"
                    Text{
                        anchors.centerIn: parent
                        text: "Remove Scheduler(if exists)"
                        color: "#cfc9c9"
                    }
                    onClicked:{
                        cont.schedulerRemoved()
                        filedownloader.del_scheduler(download_list.currentIndex,main.search)
                        cont.close()
                    }
                }
            }
        }
    }
}
