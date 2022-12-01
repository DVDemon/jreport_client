import QtQuick 2.9
import QtQuick.Controls 2.0

Page {
    id: page_id
    title: qsTr("Инициативы")
    property string title_image: "images/settings.png"

    property int border_margin :5
    property int control_spacing: 10
    property int image_size: 32

    ListModel {
        id: initiatives_model
    }

    ListModel {
        id: clusters_model
    }


    Component {
        id: initiative_delegate
        Rectangle{
            width:parent.width
            height: main_row.implicitHeight+20
            color: (name==selected_initiative)?"darkgray":"transparent"

            border{
                width: 1
                color: "lightgray"
            }


            MouseArea{
                anchors.fill: parent
                onClicked: {
                    selected_initiative = name
                    id_button1.text = issue1
                    id_button2.text = issue2
                    id_button3.text = issue3

                }
            }

            Row{
                x:control_spacing
                y:control_spacing
                spacing: control_spacing
                width: parent.width
                id:main_row

                Text {
                    id: id_name
                    text: name
                    color: font_color
                    font.family: "Hack"
                    font.bold: false
                    font.pointSize: font_size
                    wrapMode: Text.WrapAnywhere
                }
                Rectangle{
                    color: "transparent"
                    height: id_name.height
                    width: parent.width-id_name.width-control_spacing*4-id_issue1.contentWidth-id_issue2.contentWidth-id_issue3.contentWidth - (id_issue1.contentWidth>0?control_spacing:0)- (id_issue2.contentWidth>0?control_spacing:0)- (id_issue3.contentWidth>0?control_spacing:0)
                }

                Text {
                    id: id_issue1
                    text: issue1
                    color: font_color
                    font.family: "Hack"
                    font.bold: true
                    font.underline: true
                    font.pointSize: font_size
                    wrapMode: Text.WrapAnywhere
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            Qt.openUrlExternally("https://jira.mts.ru/browse/"+issue1);
                        }
                    }
                }
                Text {
                    id: id_issue2
                    text: issue2
                    color: font_color
                    font.family: "Hack"
                    font.underline: true
                    font.bold: true
                    font.pointSize: font_size
                    wrapMode: Text.WrapAnywhere
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            Qt.openUrlExternally("https://jira.mts.ru/browse/"+issue2);
                        }
                    }
                }
                Text {
                    id: id_issue3
                    text: issue3
                    color: font_color
                    font.family: "Hack"
                    font.underline: true
                    font.bold: true
                    font.pointSize: font_size
                    wrapMode: Text.WrapAnywhere
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            Qt.openUrlExternally("https://jira.mts.ru/browse/"+issue3);
                        }
                    }
                }
            }

        }

    }

    Component {
        id: cluster_delegate
        Rectangle{
            width:parent.width
            height: main_row.implicitHeight+control_spacing*2
            color: (name==selected_cluster)?"darkgray":"transparent"

            border{
                width: 1
                color: "lightgray"
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    selected_cluster = name
                }
            }

            Row{
                x:control_spacing
                y:control_spacing
                spacing: control_spacing
                width: parent.width
                id:main_row

                Text {
                    id: id_name
                    text: name
                    color: font_color
                    font.family: "Hack"
                    font.bold: false
                    font.pointSize: font_size
                    wrapMode: Text.WrapAnywhere
                }
            }

        }

    }

    Rectangle{
        anchors.fill: parent
        color: background_color
    }

    Column{
        width: parent.width
        height: parent.height

        Rectangle{
            width: control_spacing
            height: control_spacing
            color: "transparent"
        }

        Row{
            id: control_row_id
            x: control_spacing
            width: parent.width
            height: id_button1.implicitHeight

            spacing: 10
            Rectangle{
                width: id_button1.implicitWidth+20
                height: id_button1.implicitHeight+control_spacing*2
                visible: (selected_cluster!=='')&&(selected_initiative!=='')&&(id_button1.text!=='')
                color: background_color
                border{
                    width: 1
                    color: "lightgray"
                }
                radius: control_spacing
                Text {
                    id:id_button1
                    x:control_spacing
                    y:control_spacing
                    text: "Далее >>"
                    color: font_color
                    font.family: "Hack"
                    font.bold: true
                    font.pointSize: font_size
                    visible: text!==''
                    wrapMode: Text.WrapAnywhere
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        selected_initiative_epic = id_button1.text
                        stack_view_push("cluster_epic.qml")
                    }
                }

            }

            Rectangle{
                width: id_button2.implicitWidth+20
                height: id_button2.implicitHeight+control_spacing*2
                visible: (selected_cluster!=='')&&(selected_initiative!=='')&&(id_button2.text!=='')
                color: background_color
                border{
                    width: 1
                    color: "lightgray"
                }
                radius: control_spacing

                Text {
                    id:id_button2
                    x:control_spacing
                    y:control_spacing
                    text: "Далее >>"
                    color: font_color
                    font.family: "Hack"
                    font.bold: true
                    font.pointSize: font_size
                    visible: text!==''
                    wrapMode: Text.WrapAnywhere
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        selected_initiative_epic = id_button2.text
                        stack_view_push("cluster_epic.qml")
                    }
                }

            }

            Rectangle{
                width: id_button3.implicitWidth+20
                height: id_button3.implicitHeight+control_spacing*2
                visible: (selected_cluster!=='')&&(selected_initiative!=='')&&(id_button3.text!=='')
                color: background_color
                z:1
                border{
                    width: 1
                    color: "lightgray"
                }
                radius: control_spacing

                Text {
                    id:id_button3
                    x:control_spacing
                    y:control_spacing
                    text: "Далее >>"
                    color: font_color
                    font.family: "Hack"
                    font.bold: true
                    font.underline: true
                    font.pointSize: font_size
                    visible: text!==''
                    wrapMode: Text.WrapAnywhere
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        selected_initiative_epic = id_button3.text
                        stack_view_push("cluster_epic.qml")
                    }
                }

            }
        }
        Rectangle{
            width: control_spacing
            height: control_spacing*2
            color: "transparent"
        }

        Flickable{
            clip: true
            width:page_id.width
            height:page_id.height - control_row_id.height-control_spacing*3
            contentWidth: page_id.width
            contentHeight: id_column_lists.height
            boundsBehavior: Flickable.StopAtBounds


            ScrollBar.vertical: ScrollBar {
                visible: true
                active: true
            }
            Column{
                y:control_row_id.height-control_spacing*2
                id: id_column_lists
                width: parent.width
                spacing: control_spacing


                Rectangle{
                    width: control_spacing
                    height: control_spacing
                    color: "transparent"
                }

                Text {
                    x:control_spacing
                    text: "Инициативы"
                    color: font_color
                    font.family: "Hack"
                    font.bold: true
                    font.pointSize: font_size
                    wrapMode: Text.WrapAnywhere
                }

                ListView {
                    id: id_initiatives_list
                    height: id_initiatives_list.contentHeight
                    width: parent.width
                    model: initiatives_model
                    delegate: initiative_delegate
                }


                Rectangle{
                    width: control_spacing
                    height: control_spacing
                    color: "transparent"
                }

                Text {
                    x:control_spacing
                    text: "Кластера"
                    color: font_color
                    font.family: "Hack"
                    font.bold: true
                    font.pointSize: font_size
                    wrapMode: Text.WrapAnywhere
                }
                ListView {
                    id: id_clusters_list
                    height: id_clusters_list.contentHeight
                    width: parent.width
                    model: clusters_model
                    delegate: cluster_delegate
                }

                Rectangle{
                    width: control_spacing
                    height: control_spacing
                    color: "transparent"
                }


            }
        }
    }

    Connections{
            target: Downloader1
            onLoaded:{
                console.log("downloader1 loaded")
                var response = parameter
                if(response)
                {
                    var result = JSON.parse(response)
                    var length = result.length;
                    for (var i = 0; i < length; i++){
                        var msg= result[i]
                        var initiatives = msg.initiatives
                        var issues =["","",""]
                        for(var j=0; j< initiatives.length;j++)
                            issues[j] = initiatives[j]

                        initiatives_model.append({"name": msg.name,
                                                     "issue1":issues[0],
                                                     "issue2":issues[1],
                                                     "issue3":issues[2]})
                    }
                }
            }

            onConnection_error:{
                console.log("downloader1 connection error")
            }

            onAuthorization_error:{
                console.log("downloader1 authorization error");
            }
        }

    Connections{
            target: Downloader2
             onLoaded:{
                console.log("downloader2 loaded")
                 var response = parameter
                if(response)
                {
                    var result = JSON.parse(response)
                    var length = result.length;
                    for (var i = 0; i < length; i++){
                        var msg= result[i]
                        clusters_model.append({"name": msg})
                    }
                }
            }

             onConnection_error:{
                console.log("downloader2 connection error")
            }

             onAuthorization_error:{
                console.log("downloader2 authorization error");
            }
        }

    Component.onCompleted: {
        Downloader1.get(host+'/initiatives',identity)
        Downloader2.get(host+'/clusters',identity)
    }

    function init(){

    }


}
