import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import 'qrc:///'
Rectangle{
    width:20
    height:20
    color: '#28292c'
    border.width: 0.5
    border.color: 'red'
    property var checked:  marked

    Image{
        source:'qrc:///checked.jpg'
        fillMode: Image.Stretch
        visible: parent.checked
        sourceSize.height: this.height
        sourceSize.width: this.width
        anchors{
            fill:parent
            leftMargin: parent.border.width
            rightMargin: parent.border.width
            topMargin: parent.border.width
            bottomMargin: parent.border.width
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked:{
            //parent.checked = !parent.checked
            download_list.model.setProperty(index,"marked",!download_list.model.get(index).marked)   
            download_list.marked_indexes[index] = marked
            //filedownloader.log(download_list.marked_indexes)
            if(marked){
                download_list.marked_count += 1
            }else{
                download_list.marked_count -= 1
            }
        }
        onPressAndHold:{
            download_list.mark_all(!parent.checked)
        }

    }
}
