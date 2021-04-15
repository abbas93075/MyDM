import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import 'qrc:///'

TextInput{
    id:cont
    width:150
    height: 40
    property var placeHolderText:""
    property var textColor: "White"
    property var hintColor: "Black"
    signal mouseEntered()
    signal mouseExited()
    activeFocusOnPress: true
    color: hintColor
    text:placeHolderText
    onFocusChanged: {
        if(focus){
            if(text==placeHolderText)
                clear()
            color=textColor
        }else{
            if(text.length == 0){
                color=hintColor
                text=placeHolderText
            }
        }
    }

    MouseArea{
        anchors.fill: parent
        //cursorShape: "IBeamCursor"
        hoverEnabled: true
        onClicked: cont.focus = true
        onFocusChanged: {
           //do nothing
        }
        onEntered: cont.mouseEntered()
        onExited: cont.mouseExited()
    }



}

