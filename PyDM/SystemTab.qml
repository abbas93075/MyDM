import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3
import 'qrc:///'
Rectangle{
    id:cont
    width: 1248
    height: 648
    color: "#17171b"
    property var osSetModel: null
    FileDialog{
        id: destination_picker
        title: "Pick a destination"
        selectFolder: true
        onAccepted: {
            path.text = fileUrl.toString().trim().replace("file:///","")
        }

    }
    CustomButtonGroup{
        id:bg_postDownload
        selected_button: buttons[cont.osSetModel.OS.value]
        buttons: [pd_action , pd_cmd]
        onSelected_buttonChanged: {
            if(selected_button.gid == 0){
                sm.set_os(selected_button.gid , osSetModel.OS.postDown , null)
            }else{
                sm.set_os(1 , 0 , tf_cmd.text.trim())
            }
        }
    }
    ColumnLayout{
        anchors.fill: parent
        SectionTitle{
            text: "Downloads"
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            text_size: 22
            divider_color: "gray"
            divider_thickness: 2
        }
        Item{
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            Layout.alignment: Qt.AlignTop
            GridLayout{
                height:parent.height
                width:500
                columns:2
                Text{
                    Layout.preferredWidth: 130
                    text: "Download Path:"
                    font.pixelSize: 16
                    color: "white"
                    Layout.leftMargin: 7
                }
                Rectangle{
                    Layout.fillWidth: true
                    Layout.preferredHeight:  30
                    color: "#232324"
                    border.width: 0.5
                    border.color: "#74747e"
                    Layout.rightMargin: 7
                    RowLayout{
                        anchors.fill: parent
                        TextInput{
                            id:path
                            Layout.margins: 0.5
                            Layout.leftMargin: 7
                            Layout.fillWidth: true
                            color: '#cbcbcf'
                            clip:true
                            text: cont.osSetModel.Downloads.Path
                            selectionColor:"#531b1b"
                            onTextChanged: sm.set_download_path(text.trim())
                        }
                        CustomButton{

                            color: "#1c1a1a"
                            image_source: "qrc:///3d.png"
                            image_fillMode: Image.PreserveAspectFit
                            Layout.margins:2
                            Layout.preferredHeight: 25
                            Layout.preferredWidth: 40
                            onClicked: destination_picker.open()

                        }
                    }
                }
                Text{
                    Layout.preferredWidth: 190
                    text: "Simultaneous Downloads:"
                    font.pixelSize: 16
                    color: "white"
                    Layout.leftMargin: 7
                }
                CustomComboBox{
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 30
                    clip:true
                    popup.height: 150
                    model: ["1","2","3","4","5","6","7","8","9","10"]
                    currentIndex: cont.osSetModel.Downloads.SimDown-1
                    onCurrentIndexChangedByAction: sm.set_download_limit(currentIndex+1)
                }
                Text{
                    Layout.preferredWidth: 190
                    text: "Download Retries:"
                    font.pixelSize: 16
                    color: "white"
                    Layout.leftMargin: 7

                }
                CustomComboBox{
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 30
                    //currentIndex: 9
                    model: ["1","2","3","4","5","6","7","8","9","10"]
                    currentIndex:  cont.osSetModel.Downloads.Retries - 1
                    onCurrentIndexChangedByAction:  sm.set_download_retries(currentIndex + 1)
                }
            }
        }
        SectionTitle{
            text: "OS Options"
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            text_size: 22
            divider_color: "gray"
            divider_thickness: 2
        }
        Item{
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            Layout.alignment: Qt.AlignTop
            GridLayout{
                height:parent.height
                width:350
                columns:3
                CustomRadioButton{
                    id:pd_action
                    gid: 0
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    color: "transparent"
                    group: bg_postDownload
                    Layout.leftMargin: 7
                }
                Text{
                    Layout.preferredWidth: 165
                    text: "Post Download Action:"
                    font.pixelSize: 16
                    color: enabled?"white":"gray"
                    Layout.leftMargin: 7
                    enabled: pd_action.isSelectedButton()
                }
                CustomComboBox{
                    id: cmbx_pda
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 30
                    Layout.alignment: Qt.AlignLeft
                    opacity: enabled?1:0.5
                    enabled: pd_action.isSelectedButton()
                    currentIndex: cont.osSetModel.OS.postDown
                    model: ["Do Nothing","Exit","Hibernate","Shutdown"]
                    onCurrentIndexChangedByAction: {
                        sm.set_os(pd_action.gid , cmbx_pda.currentIndex , null)
                    }
                    Component.onDestruction: {
                    }
                }
                CustomRadioButton{
                    id:pd_cmd
                    gid: 1
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    color: "transparent"
                    group: bg_postDownload
                    Layout.leftMargin: 7
                }
                Text{
                    Layout.preferredWidth: 160
                    text: "Post Download CMD:"
                    font.pixelSize: 16
                    color: enabled?"white":"gray"
                    Layout.leftMargin: 7
                    enabled: pd_cmd.isSelectedButton()

                }
                TextField{
                    id:tf_cmd
                    placeholderText: "Leave be if you don't know anything about CMD"
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 30
                    placeholderTextColor: "gray"
                    opacity: enabled?1:0.5
                    enabled: pd_cmd.isSelectedButton()
                    text: cont.osSetModel.OS.postCMD
                    color: "#00fc08"
                    Layout.alignment: Qt.AlignLeft
                    selectionColor: "#044f06"
                    //currentIndex: 9
                    background:Rectangle{color: "#17171b"; border.color: "gray"}
                    onTextChanged: {
                        if(enabled){
                            sm.set_os(1 , 0 , text.trim())
                        }
                    }
                }
            }
       }
    }
    Connections{
        target: sm
    }
}
