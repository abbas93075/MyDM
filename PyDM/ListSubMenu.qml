import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import 'qrc:///'
Rectangle{
    id:cont
    color: '#28292c'
    width:150
    height:250
    border.color: "black"
    border.width: 0.5
    property var currentIndex: -1
    signal optionSelected()
    property var status
    /*function setPosition(x,y,container){
        if(x>=container.width - width)
            x = x-width-2
        if(y>=container.height - height)
            y = y-height-2
        this.x = x
        this.y = y
    }*/
    function setPosition(x,y,container){
        if(x>=container.width - width)
            x = x-width-2
        if(y>=is.y-height)
            y = y-height-2
        this.x = x
        this.y = y
    }
    function determine(status){
        return this.status == status
    }
    function sync(){
        lv.model.setProperty(0 , "enable" , determine("Completed"))
        lv.model.setProperty(1 , "enable" , determine("Completed"))
        lv.model.setProperty(2 , "enable" , status=="Paused" || status=="Failed")
        lv.model.setProperty(3 , "enable" , determine("Downloading"))
        lv.model.setProperty(4 , "enable" , determine("Completed"))
        lv.model.setProperty(6 , "enable" , determine("Completed"))
        lv.model.setProperty(7 , "enable" ,status!="Completed" && status!="Failed")
    }


    ListView{
        /*function vanish(mx , my , w , h){
            if(mx < 0 || mx > w)
                return false
            if(my < 0 || my > h)
                return false
            return true
        }*/
        id:lv
        currentIndex: cont.currentIndex
        anchors.fill: parent
        model: ListModel{
            ListElement{txt:"Open"; enable: true}
            ListElement{txt:"Show In Folder" ; enable: true}
            ListElement{txt:"Resume/Retry" ; enable: true}
            ListElement{txt:"Pause" ; enable: true}
            ListElement{txt:"Move" ; enable: true}
            ListElement{txt:"Delete" ; enable: true}
            ListElement{txt:"Remove From List" ; enable: true}
            ListElement{txt:"Schedule" ; enable:true}

        }
        delegate: CustomButton{
                        width: lv.width
                        height: 30
                        color: "transparent"
                        enabled: enable
                        Text{
                            anchors.fill:parent
                            horizontalAlignment: Qt.AlignLeft
                            verticalAlignment: Qt.AlignVCenter
                            leftPadding: 7
                            color: enabled?"#cbcbcf":"#5d6267"
                            text: txt
                        }
                        onMouseEntered: color="#21211f"
                        onMouseExited: {
                            color="transparent" ;
                            //cont.visible = lv.vanish(mouseX , mouseY , width , height)
                       }
                        onClicked: {
                            cont.currentIndex = index
                            cont.visible = false
                       }

                  }
        onCurrentIndexChanged: {
            cont.currentIndex = currentIndex
            cont.optionSelected()
       }
    }



}
