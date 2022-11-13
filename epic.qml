import QtQuick 2.9
import QtQuick.Controls 2.0

Page {
    id: page_id
    title: qsTr(selected_initiative+" для продукта "+selected_product)
    property string title_image: "images/settings.png"

    property int border_margin :5
    property int control_spacing: 10
    property int image_size: 32
    property string selected_product_issue: ""
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
            color: (key==selected_product_issue)?(saved?"darkgreen":"darkgray"):"transparent"

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
                    font.pointSize: 12
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
                    color: "white"
                    font.family: "Hack"
                    font.bold: false
                    font.pointSize: 12
                    width: 200
                    wrapMode: Text.WrapAnywhere
                }

                Text {
                    id: id_name
                    text: name
                    color: "white"
                    font.family: "Hack"
                    font.bold: false
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
                    visible: (selected_product_issue!=='')
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
                        font.pointSize: 14
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


        }
    }

    Component.onCompleted: {
        getIssuesJSON()
    }

    function init(){

    }


    function getProductEpic(product_issue) {
        var request = new XMLHttpRequest()
        var uri = host+'/product_initative_epic?';
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

        var xhr = new XMLHttpRequest();
        xhr.open("POST", host+'product_initative_issue', true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        xhr.setRequestHeader("Authorization", identity);
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
