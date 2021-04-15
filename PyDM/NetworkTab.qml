import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import 'qrc:///'
Rectangle{
    id:cont
    width: 1248
    height: 648
    color: "#17171b"
    property var netSet_model: null
    Component.onCompleted: {
        //sm.request_settings()

    }
    CustomButtonGroup{
        id:bg
        selected_button: buttons[cont.netSet_model.Proxy.value]
        buttons: [rb_noproxy,rb_proxy]
        onSelected_buttonChanged: {
                sm.set_proxy(selected_button.gid , (selected_button.gid==0)?null:tf_url.text)
        }
    }
    CustomButtonGroup{
        id: traffic
        selected_button: buttons[cont.netSet_model.Traffic.value]
        buttons: [rb_nolimit,rb_limit]
        onSelected_buttonChanged: {
            sm.set_traffic(selected_button.gid , (selected_button.gid==0)?null:netSet_model.Traffic.limit)
        }
    }
    ColumnLayout{
        anchors.fill: parent
        SectionTitle{
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            text: "Proxy"
            text_size: 22
            divider_color: "gray"
            divider_thickness: 2
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 7
        }
        Item{
            id:prxy_scn
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            Layout.alignment: Qt.AlignTop
            GridLayout{
                height: parent.height
                width: 500
                columns: 3
                CustomRadioButton{
                    id:rb_noproxy
                    gid: 0
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    group: bg
                    color: "transparent"
                    Layout.leftMargin: 7
                }
                Text{
                    Layout.columnSpan: 2
                    text: "No Proxy"
                    Layout.fillWidth: true
                    font.pixelSize: 16
                    color: enabled?"white":"#6e6b63"
                    enabled: rb_noproxy.isSelectedButton()
                }
                CustomRadioButton{
                    id:rb_proxy
                    gid: 1
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    group: bg
                    color: "transparent"
                    Layout.leftMargin: 7
                }
                Text{
                    text: "Proxy URL:"
                    Layout.preferredWidth: 75
                    font.pixelSize: 16
                    color: enabled?"white":"#6e6b63"
                    enabled: rb_proxy.isSelectedButton()               
                }
                TextField{
                    id: tf_url
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 30
                    text: cont.netSet_model.Proxy.URL
                    font.pixelSize: 16
                    color: enabled?"#d4cecd":"#6e6b63"
                    enabled: rb_proxy.isSelectedButton()
                    background: Rectangle{color: "#1c1a1a" ; border.color: "gray";  opacity: enabled?1:0.5}
                    onTextChanged: sm.set_proxy(1,text.trim())
                }
                Text{
                    text: "Username:"
                    Layout.leftMargin: 7
                    Layout.columnSpan: 2
                    Layout.preferredWidth: 100
                    font.pixelSize: 16
                    color: enabled?"white":"#6e6b63"
                    enabled: rb_proxy.isSelectedButton()
                }
                TextField{
                    id: tf_proxyUname
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 30
                    text: cont.netSet_model.Proxy.uname
                    placeholderText: "Leave Empty if None required"
                    font.pixelSize: 16
                    color: enabled?"#d4cecd":"#6e6b63"
                    enabled: rb_proxy.isSelectedButton()
                    background: Rectangle{color: "#1c1a1a" ; border.color: "gray";  opacity: enabled?1:0.5}
                    onTextChanged: sm.set_proxy_authentication(0,text.trim())
                }
                Text{
                    text: "Password:"
                    Layout.leftMargin: 7
                    Layout.columnSpan: 2
                    Layout.preferredWidth: 100
                    font.pixelSize: 16
                    color: enabled?"white":"#6e6b63"
                    enabled: rb_proxy.isSelectedButton()
                }
                TextField{
                    id: tf_proxyPasswd
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 30
                    text: cont.netSet_model.Proxy.passwd
                    placeholderText: "Leave Empty if None required"
                    font.pixelSize: 16
                    color: enabled?"#d4cecd":"#6e6b63"
                    enabled: rb_proxy.isSelectedButton()
                    background: Rectangle{color: "#1c1a1a" ; border.color: "gray";  opacity: enabled?1:0.5}
                    onTextChanged: sm.set_proxy_authentication(1,text.trim())
                }




            }

        }
        SectionTitle{
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            text: "Traffic"
            text_size: 22
            divider_color: "gray"
            divider_thickness: 2
            Layout.alignment: Qt.AlignTop
        }
        Item{
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            Layout.alignment: Qt.AlignTop
            GridLayout{
                height:parent.height
                width: 450
                columns: 3
                CustomRadioButton{
                    id:rb_nolimit
                    gid: 0
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    color: "transparent"
                    group: traffic
                    Layout.leftMargin: 7
                }
                Text{
                    Layout.columnSpan: 2
                    text: "No Download Limit"
                    Layout.fillWidth: true
                    font.pixelSize: 16
                    color: enabled?"white":"#6e6b63"
                    enabled: rb_nolimit.isSelectedButton()
                }
                CustomRadioButton{
                    id:rb_limit
                    gid: 1
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    color: "transparent"
                    group: traffic
                    Layout.leftMargin: 7
                }
                Text{
                    text: "Download Limit(KBps):"
                    Layout.preferredWidth: 160
                    font.pixelSize: 16
                    color: enabled?"white":"#6e6b63"
                    enabled: rb_limit.isSelectedButton()
                }
                CustomComboBox{
                    id:cmbx_traffic
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 30
                    model: ["10 KB/s","20 KB/s","36 KB/s","55 KB/s","105 KB/s","136 KB/s" , "210 KB/s",
                    "300 KB/s" , "400 KB/s"]
                    clip: true
                    //height:  70
                    currentIndex: cont.netSet_model.Traffic.limit
                    enabled: rb_limit.isSelectedButton()
                    popup.height: cont.height*0.153
                    opacity:  enabled?1:0.5
                    onCurrentIndexChangedByAction: {
                        if(enabled)
                            sm.set_traffic(1,currentIndex)
                   }

                }

            }
        }


    }
    Connections{
        target: sm
        onSettings_returned: {
            cont.netSet_model = request_settings.Network
        }
    }



}
