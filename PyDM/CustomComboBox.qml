import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3
import 'qrc:///'
ComboBox{
    id:cb
    //anchors.centerIn: parent
    width: 150
    model: ['Option 1' , 'Option 2', 'Option 3', 'Option 4','Option 5']
    background: Rectangle{color: "#232324";border.color: "gray"}
    popup.background: Rectangle{color: "#232324"}
    ScrollBar.vertical: ScrollBar{}
    signal currentIndexChangedByAction()
    contentItem: Text{
        font.pixelSize: 16
        width:cb.width
        leftPadding: 7
        height: cb.height
        verticalAlignment: Qt.AlignVCenter
        color: "#cbcbcf"
        text: cb.currentText
    }
    delegate:CustomButton{
        width: cb.width
        height: 30
        color: "#232324"
        Text{
            anchors.fill:parent
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            leftPadding: 7
            color: enabled?"#cbcbcf":"#5d6267"
            text: cb.model[index]
        }
        onMouseEntered: color="#21211f"
        onMouseExited: {
            color="#232324" ;
            //cont.visible = lv.vanish(mouseX , mouseY , width , height)
       }
        onClicked: {
            cb.currentIndex = index
            cb.popup.close()
       }

  }
  onCurrentIndexChanged:{
        if(popup.visible)
            currentIndexChangedByAction()
  }
}
