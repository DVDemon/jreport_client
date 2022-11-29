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
                    text: product_name
                    color: font_color
                    font.family: "Hack"
                    font.bold: false
                    font.pointSize: font_size
                    width: 200
                    wrapMode: Text.WrapAnywhere
                }

                Text {
                    id: id_name
                    text: issue_name
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
        init()
    }

    function init(){
        Downloader7.get(host+'/issues_with_products/'+selected_issue+"?initiative_epic="+selected_initiative_epic,identity)
    }

    Connections{
            target: Downloader7
            function onLoaded(response){
                console.log("downloader7 loaded")
                if(response){
                    issue1_model.clear()
                    var result = JSON.parse(response)
                    var length = result.length;

                    for (var i = 0; i < length; i++){
                        var element =result[i]
                        issue1_model.append({"key":element.product_issue,"product_name":element.product_name,"issue_name":element.product_issue_name})
                    }
                }
            }

            function onConnection_error(){
                console.log("downloader7 connection error")
            }

            function onAuthorization_error(){
                console.log("downloader7 authorization error");
            }
        }
    Connections{
            target: Downloader9
            function onLoaded(response){
                console.log("downloader9 loaded")
                if(response){
                    saved = true;
                    stackView.pop();
                    stackView.currentItem.init();
                }
            }

            function onConnection_error(){
                console.log("downloader9 connection error")
            }

            function onAuthorization_error(){
                console.log("downloader9 authorization error");
            }
        }


    function setProductEpic(){
        console.log("set product initiative issue");
        var val = JSON.stringify({
                                     product: selected_product,
                                     cluster_issue: selected_initiative_epic,
                                     product_issue: selected_product_issue
                                 });
        Downloader9.post(host+'/product_initative_issue',identity,val)
        /*var done = false
        while(!done){
            var xhr = new XMLHttpRequest();
            xhr.open("POST", host+'/product_initative_issue', false);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
            xhr.setRequestHeader("Authorization", identity);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status && xhr.status === 200) {

                        stackView.pop();
                        done = true;
                        saved = true;
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
        }*/


    }

    function getIssuesJSON() {


        console.log("loading issue: "+selected_issue);
        var done = false
        while(!done){
            var request = new XMLHttpRequest()


            request.open('GET', host+'/issue/'+selected_issue, false);
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
                        done = true;
                    } else {
                        console.log("HTTP:", request.status, request.statusText)
                    }
                }

            }
        }
        request.send()
    }
}
