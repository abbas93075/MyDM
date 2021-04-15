import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import 'qrc:///'


Rectangle{
    id:bgr
    width:parent.width
    height:10
    color:"white"
    property var value:0
    property var from:0
    property var to:255
    property var progressHeight:this.height
    property var progressRadius:this.radius
    property var progressColor:"grey"
    signal completed()
    function valTopix(){
        if(this.value < 0){
            this.value = 0
        }else if(this.value > this.to ){
            this.value = this.to
        }else if(this.value == this.to){
            this.completed()
        }

        return (bgr.value * bgr.width) / this.to
    }

    Rectangle{
       width:bgr.valTopix()
       anchors.verticalCenter: parent.verticalCenter
       height:bgr.progressHeight
       radius: bgr.progressRadius
       color: bgr.progressColor

    }
}
