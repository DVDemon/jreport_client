import QtQuick 2.9
import QtQuick.Controls 2.0

Page {
    id: page_id
    title: qsTr(selected_initiative+" кластера "+selected_cluster)
    property string title_image: "images/settings.png"

    property bool saved: false


    Rectangle{
        anchors.fill: parent
        color: background_color
    }

    ListModel {
        id: issue1_model
    }

    Component {
        id: issue_delegate
        Rectangle{
            width:parent.width
            height: main_row.implicitHeight+control_spacing*2
            color: (key==selected_issue)?(saved?"lightgreen":"darkgray"):"transparent"

            border{
                width: 1
                color: "lightgray"
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    saved = false
                    selected_issue = key
                }
            }

            Row{
                x:control_spacing
                y:control_spacing
                spacing: control_spacing
                width: parent.width
                id:main_row

                Text {
                    id: id_key
                    text: key
                    color: font_color
                    font.family: "Hack"
                    font.bold: false
                    font.pointSize: font_size
                    font.underline: true
                    width:100
                    wrapMode: Text.WrapAnywhere
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            Qt.openUrlExternally("https://jira.mts.ru/browse/"+key);
                        }
                    }
                }
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


    Column{
        width: parent.width
        height: parent.height

        Row{
            x:control_spacing
            y:control_spacing
            spacing: control_spacing
            id: control_row_id
            width: parent.width
            height: id_button.implicitHeight+control_spacing*2

            Rectangle{
                width: id_button.width+control_spacing*2
                height: id_button.implicitHeight+control_spacing*2
                visible: (selected_issue!=='')
                color: "transparent"
                radius: control_spacing
                z:1


                border{
                    width: 1
                    color: "lightgray"
                }
                Text {
                    id:id_button
                    x:control_spacing
                    y:control_spacing
                    text: "Save >>"
                    color: font_color
                    font.family: "Hack"
                    font.bold: true
                    font.pointSize: font_size
                    wrapMode: Text.WrapAnywhere
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        setClusterInitiativeEpic()
                    }
                }

            }

            Rectangle{
                width: id_button2.width+control_spacing*2
                height: id_button2.implicitHeight+control_spacing*2
                visible: (selected_issue!=='')
                color: "transparent"
                radius: control_spacing


                border{
                    width: 1
                    color: "lightgray"
                }
                Text {
                    id:id_button2
                    x:control_spacing
                    y:control_spacing
                    text: "Products >>"
                    color: font_color
                    font.family: "Hack"
                    font.bold: true
                    font.pointSize: font_size
                    wrapMode: Text.WrapAnywhere
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        stack_view_push("product_epic.qml")
                    }
                }

            }
        }

        Rectangle{
            width: control_spacing
            height: control_spacing
            color: "transparent"
        }

        Flickable{

            width:parent.width
            height:parent.height -control_row_id.height-control_spacing*2
            contentWidth: parent.width
            contentHeight: id_column_lists.height
            boundsBehavior: Flickable.StopAtBounds
            clip: true


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
                    id:id_issue_title_1
                    x:control_spacing
                    text: "Эпики"
                    color: font_color
                    font.family: "Hack"
                    font.bold: true
                    font.pointSize: font_size
                    wrapMode: Text.WrapAnywhere
                }

                ListView {
                    id: id_issue_list
                    height: id_issue_list.contentHeight
                    width: parent.width
                    model: issue1_model
                    delegate: issue_delegate
                }




            }
        }
    }

    Connections{
            target: Downloader3
            onLoaded : {
                console.log("downloader3 loaded")
                var response = parameter
                if(response)
                {
                    var result = JSON.parse(response)
                    var links  = result.links;
                    var length = links.length;
                    issue1_model.clear()
                    id_issue_title_1.text = result.key+": "+result.name
                    for (var i = 0; i < length; i++){
                        var element= links[i]

                        if(element.type==="parent of"){
                            issue1_model.append({"key": element.issue.key,
                                                    "name":element.issue.name})
                        }
                    }

                    var uri = host+'/cluster_initative_epic?';
                    uri += 'cluster='+encodeURIComponent(selected_cluster);
                    uri += '&initiative_issue='+encodeURIComponent(selected_initiative_epic);
                    Downloader4.get(uri,identity)
                }
            }

            onConnection_error:{
                console.log("downloader3 connection error")
            }

            onAuthorization_error:{
                console.log("downloader3 authorization error");
            }
        }

    Connections{
            target: Downloader4
            onLoaded:{
                console.log("downloader4 loaded")
                var response = parameter
                if(response)
                {
                    var result = JSON.parse(response)
                    selected_issue = result.issue;
                }
            }

            onConnection_error:{
                console.log("downloader4 connection error")
            }

            onAuthorization_error:{
                console.log("downloader4 authorization error");
            }
        }
    Connections{
            target: Downloader5
            onLoaded:{
                var response = parameter
                console.log("downloader5 loaded")
                saved = true
            }

            onConnection_error:{
                console.log("downloader4 connection error")
            }

            onAuthorization_error:{
                console.log("downloader4 authorization error");
            }
        }

    Component.onCompleted: {
        Downloader3.get(host+'/issue/'+selected_initiative_epic,identity)

    }

    function init(){

    }

    function setClusterInitiativeEpic(){

        var val = JSON.stringify({
                                       cluster: selected_cluster,
                                       initiative: selected_initiative,
                                       initiative_issue: selected_initiative_epic,
                                       issue: selected_issue
                                   });
        Downloader5.post(host+'/cluster_initative_epic',identity,val)
    }
}
