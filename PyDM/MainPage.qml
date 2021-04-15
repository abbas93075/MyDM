import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3
import 'qrc:///'
Rectangle{
    //anchors.fill: parent
    id:main
    anchors.fill: parent
    property var action_btn_color: 'red'
    property var regex: null
    property var loaded: false
    property var search: (regex!=null)
    Component.onCompleted: {
        main.loaded = true
        filedownloader.request_load_info()
        list_updater.running = true
   }
    Timer{
        id: list_updater
        interval: 100
        repeat: true
        running: false
        property var current: 0
        onTriggered: {
            filedownloader.request_model(main.regex)
            filedownloader.request_additional_info(download_list.currentIndex , main.search)
        }
        function sync(datalist){
            if(download_list.count == 0){
                if(datalist.length > 0){
                    download_list.model.append(datalist)
                    if(main.loaded)
                        download_list.mark_all(false)
                }
                return
            }
            for(this.current=0 ; this.current<download_list.model.count ; this.current++){
                download_list.model.set(this.current , datalist[this.current])
            }
            this.current = 0
        }
    }

    AddDownloadDialog{
        id:add_dwnld
        onAccepted: {
            filedownloader.add(url , defaultpath)
            filedownloader.request_process_info(main.regex)
            list_updater.start()
        }
    }
    FileDialog{
        id:move_file
        selectFolder: true
        onAccepted: filedownloader.move(download_list.currentIndex , fileUrl.toString().replace("file:///",""))
    }
    CustomMessageDialog{id:msd}
    DeleteDownloadDialog{
        id:delete_dwnld
        function delete_download(disk){
            if(range){
                let j=0 , shifts=0 ;
                while(j<download_list.marked_indexes.length){
                    if(download_list.marked_indexes[j]){
                        if(!disk && download_list.model.get(j).status != "Completed"){
                            j++
                            continue
                        }
                        filedownloader.remove(j,disk,main.search,shifts)
                        download_list.remove(j)
                        download_list.marked_count--
                        shifts++
                    }else{
                        j++
                    }
                }
            }else{
                filedownloader.remove(download_list.currentIndex,disk,main.search,0)
                download_list.remove(download_list.currentIndex)
            }
        }
        onListAccepted: {
            delete_download(false)
        }
        onDiskAccepted: {
            delete_download(true)
        }
    }
    SchedulerDialog{
        id:scheduler
        onVisibilityChanged: {
            if(!visible)
                filedownloader.resume(download_list.currentIndex , main.search)
        }

    }

    Rectangle{
        anchors.fill: parent
        color: '#28292c'
        ColumnLayout{
            anchors.fill: parent
            spacing: 3
            Rectangle{
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                Layout.preferredHeight: 75
                RowLayout{
                    id: download_fcn_btns
                    anchors.fill: parent
                    Layout.margins: 0
                    RowLayout{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 1

                        CustomButton{
                            id:add
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: main.action_btn_color
                            radius: 0
                            Layout.alignment: Qt.AlignLeft
                            onMouseEntered: {
                                color='#E3372B' ;
                                overlap_ma.cursorShape = Qt.PointingHandCursor
                            }
                            onMouseExited:{
                                color=main.action_btn_color
                                overlap_ma.cursorShape = Qt.ArrowCursor
                            }
                            image_fillMode: Image.PreserveAspectFit
                            image_source: 'qrc:///add.png'
                            cursorShape: Qt.PointingHandCursor
                            padding: 15
                            onClicked: {
                                if(download_list.count == 100){
                                    msd.show()
                                }else{
                                    add_dwnld.show()
                                }
                            }


                        }
                        CustomButton{
                            id:start
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: main.action_btn_color
                            radius: 0
                            Layout.alignment: Qt.AlignLeft
                            onMouseEntered: {
                                color='#E3372B' ;
                                overlap_ma.cursorShape = Qt.PointingHandCursor
                            }
                            onMouseExited:{
                                color=main.action_btn_color
                                overlap_ma.cursorShape = Qt.ArrowCursor
                            }
                            image_fillMode: Image.PreserveAspectFit
                            image_source: 'qrc:///start-tst.png'
                            cursorShape: Qt.PointingHandCursor
                            padding: 15
                            onClicked: {
                                if(download_list.marked_count > 0)
                                    filedownloader.resume(download_list.marked_indexes , main.search)
                                else
                                    filedownloader.resume(download_list.currentIndex , main.search)
                            }
                        }
                        CustomButton{
                            id:pause
                            color: main.action_btn_color
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            radius: 0
                            Layout.alignment: Qt.AlignLeft
                            onMouseEntered: {
                                color='#E3372B' ;
                                overlap_ma.cursorShape = Qt.PointingHandCursor
                            }
                            onMouseExited:{
                                color=main.action_btn_color
                                overlap_ma.cursorShape = Qt.ArrowCursor
                            }
                            image_source: 'qrc:///pause.png'
                            image_fillMode: Image.PreserveAspectFit
                            cursorShape: Qt.PointingHandCursor
                            padding: 15
                            onClicked: {
                                if(download_list.marked_count > 0)
                                    filedownloader.pause(download_list.marked_indexes,main.search)
                                else
                                    filedownloader.pause(download_list.currentIndex,main.search)
                            }
                        }
                        CustomButton{
                            id:del_download
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            radius: 0
                            color: main.action_btn_color
                            Layout.alignment: Qt.AlignLeft
                            onMouseEntered: {
                                color='#E3372B' ;
                                overlap_ma.cursorShape = Qt.PointingHandCursor
                            }
                            onMouseExited:{
                                color=main.action_btn_color
                                overlap_ma.cursorShape = Qt.ArrowCursor
                            }
                            image_source: 'qrc:///delete.png'
                            image_fillMode: Image.PreserveAspectFit
                            cursorShape: Qt.PointingHandCursor
                            padding: 15
                            onClicked: {
                                if(download_list.model.count > 0){
                                    delete_dwnld.range = (download_list.marked_count > 0)
                                    delete_dwnld.show()
                                }

                            }
                        }
                        CustomButton{
                            id:prgrm_settings
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: main.action_btn_color
                            radius: 0
                            Layout.alignment: Qt.AlignLeft
                            onMouseEntered: {
                                color='#E3372B' ;
                                overlap_ma.cursorShape = Qt.PointingHandCursor
                            }
                            onMouseExited:{
                                color=main.action_btn_color
                                overlap_ma.cursorShape = Qt.ArrowCursor
                            }
                            image_source: 'qrc:///settings.png'
                            image_fillMode: Image.PreserveAspectFit
                            cursorShape: Qt.PointingHandCursor
                            padding: 15
                            onClicked: ploader.source = "SettingsPage.qml"
                        }
                        CustomButton{
                            id:post_download
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: main.action_btn_color
                            property var active:false
                            radius: 0
                            Layout.alignment: Qt.AlignLeft
                            onMouseEntered: {
                                color='#E3372B' ;
                                overlap_ma.cursorShape = Qt.PointingHandCursor
                            }
                            onMouseExited:{
                                color=main.action_btn_color
                                overlap_ma.cursorShape = Qt.ArrowCursor
                            }
                            image_source: active?'qrc:///pbtn_on.png':'qrc:///pbtn_off.png'
                            image_fillMode: Image.PreserveAspectFit
                            cursorShape: Qt.PointingHandCursor
                            padding: 15
                            onClicked: {
                                active = !active
                                filedownloader.shutdown_on_complete()
                            }
                        }

                       SearchModule{
                            id:search
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignRight

                        }

                    }
                }



            }
            ListView{
                function current_dict(){
                    return model.get(currentIndex)
                }
                function show_side_menu(){
                    sub_men.status = current_dict().status
                    sub_men.currentIndex = -1
                    sub_men.sync()
                    sub_men.setPosition(overlap_ma.mouseX,overlap_ma.mouseY,download_list)
                    sub_men.visible = true
                }
                function mark_all(mark){
                    marked_indexes.splice(0,marked_indexes.length)
                    for(var i=0 ; i<count ; i++){
                        marked_indexes.push(mark)
                        model.setProperty(i,"marked",mark)
                    }
                    marked_count = mark?marked_indexes.length:0
                }
                function remove(index){
                    model.remove(index)
                    marked_indexes.splice(index,1)
                }

                property var marked_indexes : []
                property var marked_count: 0
                id:download_list
                model: ListModel{}
                delegate: DownloadListDelegate{
                    width:download_list.width
                }
                //highlightFollowsCurrentItem: true
                //highlightMoveDuration: 1
                clip:true
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                onCurrentIndexChanged: filedownloader.request_additional_info(currentIndex,main.search)
                ScrollBar.vertical: ScrollBar{
                   id:dlsb

                }


            }
          InfoSection{
            id:is
            up:false
            Layout.fillWidth: true
            Layout.preferredHeight: up?208:30
            Layout.alignment: Qt.AlignBottom
            visible: download_list.currentIndex != -1
            //visible: false

          }
        }
        ///////


    }
    Rectangle{
        anchors.fill: parent
        color: "black"
        opacity: 0.5
        visible: add_dwnld.visible || delete_dwnld.visible || scheduler.visible || msd.visible
    }
    Text{
        anchors.centerIn: overlap_ma
        font.pixelSize: 25
        text: "Empty Download List press (+) to add download Links"
        color: "white"
        visible: download_list.currentIndex == -1 && !main.search
    }
    ListSubMenu{
        id:sub_men
        visible: false
        onOptionSelected : {
            switch(currentIndex){
            case 0:
                filedownloader.open_explorer(download_list.currentIndex , true , main.search)
                break ;
            case 1:
                filedownloader.open_explorer(download_list.currentIndex , false , main.search)
                break;
            case 2:
                filedownloader.resume(download_list.currentIndex , main.search)
                break;
            case 3:
                filedownloader.pause(download_list.currentIndex,main.search)
                break;
            case 4:
                move_file.open()
                break;
            case 5:
                filedownloader.remove(download_list.currentIndex,true,main.search,0)
                download_list.remove(download_list.currentIndex)
                break;
            case 6:
                filedownloader.remove(download_list.currentIndex,false,main.search,0)
                download_list.remove(download_list.currentIndex)
                break;
            case 7:
                filedownloader.pause(download_list.currentIndex,main.search)
                scheduler.show()
                break;
            default:
                sync()

            }
        }
    }
    MouseArea{
        function in_range(x , y , w , h){
            return ((mouseX >= x && mouseX <= x+w ) && (mouseY >= y && mouseY <= y+h) )
        }
        id:overlap_ma
        anchors.fill: parent
        //onClicked: this.focus=true
        propagateComposedEvents: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        //cursorShape: Qt.ArrowCursor
        visible: !dlsb.active
        onClicked:{
            search.finish()
            if(!in_range(sub_men.x , sub_men.y , sub_men.width , sub_men.height))
                sub_men.visible = false
            mouse.accepted=false
        }
    }
    Connections{
        target:filedownloader
        onDownloadLink_returned: {
            add_dwnld.url = request_clipboard_link[0]
            add_dwnld.defaultpath = request_clipboard_link[1]
        }
        onDownloadInfo_returned: {
            download_list.model.append(request_process_info) ;
            download_list.model.setProperty(download_list.count -1,"marked",false)
            download_list.marked_indexes.push(false)
            download_list.currentIndex = download_list.count - 1
        }
        onDownloadModel_returned:{
            list_updater.sync(request_model)
        }
        onLink_approved: {add_dwnld.validUrl = check_link}
        onAdditional_info_returned: is.info = request_additional_info
        onPending_started: download_list.currentIndex = _resume_pending
        onLoadInfo_returned: post_download.active = request_load_info
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
