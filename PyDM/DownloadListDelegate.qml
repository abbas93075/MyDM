import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import 'qrc:///'
Rectangle{
    id:cont
    width:1240
    height:30
    color: '#28292c'
    border.color: ListView.isCurrentItem?'red':'#4d4e51'
    border.width: 0.5
    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.RightButton | Qt.LeftButton
        onClicked: {
            download_list.currentIndex = index
            if(mouse.button & Qt.RightButton)
                download_list.show_side_menu()
        }
    }
    RowLayout{
        spacing: 0
        anchors{
            fill: parent
            topMargin: parent.border.width
            leftMargin: parent.border.width
            rightMargin: parent.border.width
            bottomMargin: parent.border.width
        }
        CustomCheckbox{
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            Layout.leftMargin: 7
        }
        Image{
            id:img
            Layout.preferredHeight: 20
            Layout.preferredWidth: 20
            source:'qrc:///folder_icon.png'
            sourceSize.width: width
            sourceSize.height: height
            Layout.alignment: Qt.AlignLeft
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                enabled: status == "Completed"
                onEntered: img.source = "qrc:///folder_icon_opened.png"
                onExited: img.source = "qrc:///folder_icon.png"
                cursorShape: (status=="Completed")?Qt.PointingHandCursor:Qt.ArrowCursor
                onClicked: {
                    filedownloader.open_explorer(index , false , main.search)
                }
            }
        }
        Text{
            text:name
            elide: Text.ElideRight
            //Layout.preferredWidth: 388
            Layout.preferredWidth: cont.width / 3.195
            color: '#cbcbcf'
            font.pixelSize: 16
        }
        Text{
            text:speed
            color: '#5d6267'
            font.pixelSize: 16
            Layout.preferredWidth: 120
        }
        Text{
            function determineColor(stat){
                if(stat == "Downloading" || stat == "Pending")
                    return "#c6c313"
                else if(stat == "Paused" || stat == "Failed" || stat=="Stopped")
                    return "#f93535"
                else if(stat == "Completed")
                    return "#50f935"
                else if(stat=="Scheduled")
                    return "#627066"
            }
            color: determineColor(status)
            text:status
            font.pixelSize: 16
            Layout.preferredWidth : 90
        }
        CustomProgressBar{
            Layout.preferredWidth:  180
            Layout.preferredHeight: 15
            radius: 8
            border.color: 'black'
            border.width: 0.5
            color: 'white'
            progressColor: 'red'
            from: 0
            to:100
            value:progress
            visible: (status == "Downloading" || status == "Paused")
        }
        Text{
            text:progress+"%"
            color: '#cbcbcf'
            font.pixelSize: 16
            Layout.preferredWidth : 40
            visible: (status == "Downloading" || status == "Paused")
        }
    }
}
