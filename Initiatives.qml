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
                x:10
                y:10
                spacing: control_spacing
                width: parent.width
                id:main_row

                Text {
                    id: id_name
                    text: name
                    color: "white"
                    font.family: "Hack"
                    font.bold: true
                    font.pointSize: 12
                    wrapMode: Text.WrapAnywhere
                }
                Rectangle{
                    color: "transparent"
                    height: id_name.height
                    width: parent.width-id_name.width-id_issue1.width-id_issue2.width-id_issue3.width-60
                }

                Text {
                    id: id_issue1
                    text: issue1
                    color: "lightblue"
                    font.family: "Hack"
                    font.bold: true
                    font.underline: true
                    font.pointSize: 12
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
                    color: "lightblue"
                    font.family: "Hack"
                    font.underline: true
                    font.bold: true
                    font.pointSize: 12
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
                    color: "lightblue"
                    font.family: "Hack"
                    font.underline: true
                    font.bold: true
                    font.pointSize: 12
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
                x:10
                y:10
                spacing: control_spacing
                width: parent.width
                id:main_row

                Text {
                    id: id_name
                    text: name
                    color: "white"
                    font.family: "Hack"
                    font.bold: true
                    font.pointSize: 12
                    wrapMode: Text.WrapAnywhere
                }
            }

        }

    }

    Flickable{

        width:page_id.width
        height:page_id.height
        contentWidth: page_id.width
        contentHeight: id_column_lists.height
        boundsBehavior: Flickable.StopAtBounds


        ScrollBar.vertical: ScrollBar {
            visible: true
            active: true
        }
        Column{
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
                color: "white"
                font.family: "Hack"
                font.bold: true
                font.pointSize: 12
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
                color: "white"
                font.family: "Hack"
                font.bold: true
                font.pointSize: 12
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

            Row{
                width: parent.width
                height: id_button1.implicitHeight

                spacing: 10
                Rectangle{
                    width: id_button1.implicitWidth+20
                    height: id_button1.implicitHeight+control_spacing*2
                    visible: (selected_cluster!='')&&(selected_initiative!='')
                    color: "transparent"
                    border{
                        width: 1
                        color: "lightgray"
                    }
                    Text {
                        id:id_button1
                        x:control_spacing
                        y:control_spacing
                        text: "Далее >>"
                        color: "lightblue"
                        font.family: "Hack"
                        font.bold: true
                        font.underline: true
                        font.pointSize: 14
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
                    visible: (selected_cluster!='')&&(selected_initiative!='')
                    color: "transparent"
                    border{
                        width: 1
                        color: "lightgray"
                    }
                    Text {
                        id:id_button2
                        x:control_spacing
                        y:control_spacing
                        text: "Далее >>"
                        color: "lightblue"
                        font.family: "Hack"
                        font.bold: true
                        font.underline: true
                        font.pointSize: 14
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
                    visible: (selected_cluster!=='')&&(selected_initiative!='')
                    color: "transparent"
                    border{
                        width: 1
                        color: "lightgray"
                    }
                    Text {
                        id:id_button3
                        x:control_spacing
                        y:control_spacing
                        text: "Далее >>"
                        color: "lightblue"
                        font.family: "Hack"
                        font.bold: true
                        font.underline: true
                        font.pointSize: 14
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
                height: control_spacing
                color: "transparent"
            }


        }
    }

    Component.onCompleted: {
        getInitiativesJSON()
        getClustersJSON()
    }

    function init(){

    }


    function getInitiativesJSON() {
        var request = new XMLHttpRequest()
        request.open('GET', 'http://192.168.64.6/initiatives', true);
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    var result = JSON.parse(request.responseText)
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
                } else {
                    console.log("HTTP:", request.status, request.statusText)
                }
            }
        }
        request.send()
    }

    function getClustersJSON() {
        var request = new XMLHttpRequest()
        request.open('GET', 'http://192.168.64.6/clusters', true);
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    var result = JSON.parse(request.responseText)
                    var length = result.length;
                    for (var i = 0; i < length; i++){
                        var msg= result[i]
                        clusters_model.append({"name": msg})
                    }
                } else {
                    console.log("HTTP:", request.status, request.statusText)
                }
            }
        }
        request.send()
    }
}
