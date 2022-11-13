import QtQuick 2.9
import QtQuick.Controls 2.0

Page {
    id: page_id
    title: qsTr(selected_initiative+" кластера "+selected_cluster)
    property string title_image: "images/settings.png"

    property int border_margin :5
    property int control_spacing: 10
    property int image_size: 32

    property bool saved: false


    Rectangle{
        anchors.fill: parent
        color: "black"
    }

    ListModel {
        id: issue1_model
    }

    Component {
        id: issue_delegate
        Rectangle{
            width:parent.width
            height: main_row.implicitHeight+control_spacing*2
            color: (key==selected_issue)?(saved?"darkgreen":"darkgray"):"transparent"

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
                x:10
                y:10
                spacing: control_spacing
                width: parent.width
                id:main_row

                Text {
                    id: id_key
                    text: key
                    color: "white"
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
                    color: "white"
                    font.family: "Hack"
                    font.bold: false
                    font.pointSize: font_size
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
                id:id_issue_title_1
                x:control_spacing
                text: "Эпики"
                color: "white"
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

            Row{
                width: parent.width
                height: id_button.implicitHeight+control_spacing*2

                Rectangle{
                    width: id_button.width+control_spacing*2
                    height: id_button.implicitHeight+control_spacing*2
                    visible: (selected_issue!=='')
                    color: "transparent"


                    border{
                        width: 1
                        color: "lightgray"
                    }
                    Text {
                        id:id_button
                        x:control_spacing
                        y:control_spacing
                        text: "Save >>"
                        color: "lightblue"
                        font.family: "Hack"
                        font.bold: true
                        font.underline: true
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


                    border{
                        width: 1
                        color: "lightgray"
                    }
                    Text {
                        id:id_button2
                        x:control_spacing
                        y:control_spacing
                        text: "Products >>"
                        color: "lightblue"
                        font.family: "Hack"
                        font.bold: true
                        font.underline: true
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


        }
    }

    Component.onCompleted: {
        getIssuesJSON()
    }

    function init(){

    }

    function setClusterInitiativeEpic(){

        var xhr = new XMLHttpRequest();
        xhr.open("POST", host+'/cluster_initative_epic', true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        xhr.setRequestHeader("Authorization", identity);
        xhr.send(JSON.stringify({
            cluster: selected_cluster,
            initiative: selected_initiative,
            initiative_issue: selected_initiative_epic,
            issue: selected_issue
        }));
        saved = true;
    }

    function getClusterInitiativeEpic() {
        var request = new XMLHttpRequest()
        selected_issue =""
        var uri = host+'/cluster_initative_epic?';
        uri += 'cluster='+encodeURIComponent(selected_cluster);
        uri += '&initiative='+encodeURIComponent(selected_initiative);
        uri += '&initiative_issue='+encodeURIComponent(selected_initiative_epic);

        request.open('GET', uri, true);
        request.setRequestHeader("Authorization", identity);
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    console.log("response", request.responseText)
                    var result = JSON.parse(request.responseText)
                    selected_issue = result.issue;
                    saved = true;
                } else {
                    console.log("HTTP:", request.status, request.statusText)
                }
            }

        }
        request.send()
    }

    function getIssuesJSON() {
        var request = new XMLHttpRequest()

        request.open('GET', host+'/issue/'+selected_initiative_epic, true);
        request.setRequestHeader("Authorization", identity);
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    //console.log("response", request.responseText)
                    var result = JSON.parse(request.responseText)
                    var links  = result.links;
                    var length = links.length;
                    id_issue_title_1.text = result.key+": "+result.name
                    for (var i = 0; i < length; i++){
                        var element= links[i]

                        if(element.type==="parent of"){
                            issue1_model.append({"key": element.issue.key,
                                                    "name":element.issue.name})
                        }
                    }
                    getClusterInitiativeEpic();
                } else {
                    console.log("HTTP:", request.status, request.statusText)
                }
            }

        }
        request.send()
    }
}
