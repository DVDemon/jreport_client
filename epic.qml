import QtQuick 2.9
import QtQuick.Controls 2.0

Page {
    id: page_id
    title: qsTr(selected_initiative+" для продукта "+selected_product)
    property string title_image: "images/settings.png"
    property string selected_product_issue: ""
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
            color: (key==selected_product_issue)?(saved?"lightgreen":"darkgray"):"transparent"

            border{
                width: 1
                color: "lightgray"
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    saved = false
                    selected_product_issue = key
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
                    id: id_product_epic
                    text: getProductEpic(key)
                    color: font_color
                    font.family: "Hack"
                    font.bold: false
                    font.pointSize: font_size
                    width: 200
                    wrapMode: Text.WrapAnywhere
                }

                Text {
                    id: id_name
                    text: name
<<<<<<< HEAD
                    color: font_colors
=======
                    color: font_color
>>>>>>> 362d5792e5219e97940dfbe98d67c3c7e80ccf6e
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
                visible: (selected_product_issue!=='')
                color: "transparent"
                radius: control_spacing

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
                    font.underline: true
                    font.pointSize: font_size
                    wrapMode: Text.WrapAnywhere
                }



                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        setProductEpic()
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

            width:page_id.width
            height:page_id.height-control_row_id.height-control_spacing*2
            contentWidth: page_id.width
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

    Component.onCompleted: {
        getIssuesJSON()
    }

    function init(){

    }


    function getProductEpic(product_issue) {
        var request = new XMLHttpRequest()
        var uri = host+'/product_initative_issue?';
        uri += 'product_issue='+encodeURIComponent(product_issue);
        uri += '&cluster_issue='+encodeURIComponent(selected_initiative_epic);

        var result_issue = ""
        request.open('GET', uri, false);
        request.setRequestHeader("Authorization", identity);
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    var result = JSON.parse(request.responseText)
                    result_issue = result.issue;
                } else {
                    console.log("HTTP:", request.status, request.statusText)

                }
            }

        }
        request.send()
        return result_issue;
    }

    function setProductEpic(){
        console.log("set product initiative issue");
        var xhr = new XMLHttpRequest();
        xhr.open("POST", host+'/product_initative_issue', true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        xhr.setRequestHeader("Authorization", identity);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status && xhr.status === 200) {

                    stackView.pop();
                } else {
                    console.log("HTTP:", xhr.status, xhr.statusText)
                }
            }

        }
        xhr.send(JSON.stringify({
                                    product: selected_product,
                                    cluster_issue: selected_initiative_epic,
                                    product_issue: selected_product_issue
                                }));
        saved = true;
    }

    function getIssuesJSON() {
        var request = new XMLHttpRequest()

        console.log("loading issue: "+selected_issue);
        request.open('GET', host+'/issue/'+selected_issue, true);
        request.setRequestHeader("Authorization", identity);
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    //console.log("response", request.responseText)
                    var result = JSON.parse(request.responseText)
                    var links  = result.links;
                    var length = links.length;
                    for (var i = 0; i < length; i++){
                        var element= links[i]

                        if(element.type==="parent of"){
                            issue1_model.append({"key": element.issue.key,
                                                    "name":element.issue.name})
                        }
                    }
                } else {
                    console.log("HTTP:", request.status, request.statusText)
                }
            }

        }
        request.send()
    }
}
