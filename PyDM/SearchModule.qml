import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import 'qrc:///'
Rectangle{
    id:container
    width:100
    height:40
    border.color: "black"
    color: '#28292c'
    border.width: 1
    focus: true
    //anchors.centerIn: parent
    function finish(){
        cti.focus = false
    }
    RowLayout{
        anchors.fill: parent
        anchors.margins: parent.border.width
        spacing: 7
        TextField{
            id:cti
            Layout.fillHeight: true
            Layout.fillWidth: true
            placeholderText: "Search..."
            activeFocusOnPress: true
            verticalAlignment: Text.AlignVCenter
            color:  "#cbcbcf"
            background: Rectangle{color: container.color}
            leftPadding: 15
            font.pixelSize: 25
            focus:container.focus
            clip:true
            onTextChanged: {
                download_list.model.clear()
                if(text=="")
                    main.regex = null
                else
                    main.regex = text.trim()
                //download_list.mark_all(false)
                filedownloader.match(main.regex)
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    container.focus = true
                    cti.focus = true

                }
                onEntered: overlap_ma.cursorShape = Qt.IBeamCursor
                onExited: overlap_ma.cursorShape = Qt.ArrowCursor
            }


        }
        CustomButton{
            Layout.fillHeight: true
            Layout.preferredWidth: 45
            //color: "green"
            //radius: parent.radius
            color: container.color
            onClicked: cti.focus=false
            image_source: 'qrc:///search.svg'
            image_fillMode: Image.PreserveAspectFit
        }

    }

}



