import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import 'qrc:///'
Rectangle{
    id:cont
    color:'#28292c'
    width:200
    height: 30
    radius: 8
    property var mode: 0
    property var t:[0,0,0]
    signal timeChanged()
    function _bind(v , min , max){
        if(v<min)
            v=max
        else if(v>max)
            v=min
        return v
    }
    function set_time(by){
        t[mode] += by
        if(mode == 0){
            t[mode] = _bind(t[mode],0,23)
        }else{
            t[mode] = _bind(t[mode],0,59)
        }
        time.text = string_time()
    }
    function string_mode(){
        if(mode==0){
            return "h"
        }else if(mode == 1){
            return "m"
        }else{
            return"s"
        }
    }
    function string_time(){
        return [tdf(t[0]),tdf(t[1]),tdf(t[2])].join(":")
    }
    function tdf(nb) {
        return ("0"+nb).slice(-2)
    }
    function change_mode(by){
        mode += by
        if(mode < 0)
            mode = 2
        else if(mode > 2)
            mode = 0
    }
    Timer{
        id:tmr
        running: false
        property var action: null
        property var args: null
        repeat: true
        interval: 150
        onTriggered: {
            action(args)
        }
    }
    RowLayout{
        anchors.fill: parent
        Text{
            Layout.preferredHeight: 25
            Layout.preferredWidth: 25
            font.pixelSize: 18
            color:'#cbcbcf'
            text:cont.string_mode()
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
        }
        ColumnLayout{
            Layout.preferredWidth: 21
            Layout.preferredHeight: 21
            spacing: 0
            CustomButton{
                Layout.fillHeight: true
                Layout.fillWidth: true
                image_source: "qrc:///info_up.png"
                color: "transparent"
                image_fillMode: Image.PreserveAspectFit
                radius: 8
                padding: 2
                onClicked: cont.change_mode(1)
            }
            CustomButton{
                Layout.fillHeight: true
                Layout.fillWidth: true
                image_source: "qrc:///info_down.png"
                image_fillMode: Image.PreserveAspectFit
                color: "transparent"
                radius: 8
                padding: 2
                onClicked: cont.change_mode(-1)
            }
        }
        Text{
            id:time
            Layout.preferredHeight: 25
            Layout.fillWidth: true
            font.pixelSize: 18
            color:'#cbcbcf'
            text:cont.string_time()
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
        }
        ColumnLayout{
            Layout.preferredWidth: 21
            Layout.preferredHeight: 21
            spacing: 0
            CustomButton{
                Layout.fillHeight: true
                Layout.fillWidth: true
                image_source: "qrc:///info_up.png"
                color: cont.color
                image_fillMode: Image.PreserveAspectFit
                radius: 8
                padding: 2
                onClicked: {
                    cont.set_time(1)
                    cont.timeChanged()
                }
                onHold: {
                    tmr.action = cont.set_time
                    tmr.args = 1
                    tmr.running = true
               }
               onReleased: tmr.running = false

            }
            CustomButton{
                Layout.fillHeight: true
                Layout.fillWidth: true
                image_source: "qrc:///info_down.png"
                image_fillMode: Image.PreserveAspectFit
                color: cont.color
                radius: 8
                padding: 2
                onClicked: {
                    cont.set_time(-1)
                    cont.timeChanged()
                }
                onHold: {
                    tmr.action = cont.set_time
                    tmr.args = -1
                    tmr.running = true
               }
               onReleased: tmr.running = false
            }
        }
    }
}



