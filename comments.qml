import QtQuick 2.9
import QtQuick.Controls 2.0

Page {
    id: page_id
    title: qsTr("Комментарий к "+selected_product)
    property string title_image: "images/settings.png"



    property string product_report_address;
    property string product_comment;

    Rectangle{
        anchors.fill: parent
        color: background_color
    }

    Flickable{

        width:page_id.width
        height:page_id.height
        contentWidth: page_id.width
        contentHeight: id_column_lists.height
        boundsBehavior: Flickable.StopAtBounds


        ScrollBar.vertical: ScrollBar {
            visible: false
            active: false
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
                text: "Адрес отчета"
                color: font_color
                font.family: "Hack"
                font.bold: true
                font.pointSize: font_size
                wrapMode: Text.WrapAnywhere
            }

            TextField{
                x: control_spacing
                text: product_report_address
                color: font_color
                width: parent.width-control_spacing*2
                selectByMouse: true
                onTextChanged: product_report_address = text
            }

            Rectangle{
                width: control_spacing
                height: control_spacing
                color: "transparent"
            }

            Text {
                x:control_spacing
                text: "Комментарий"
                color: font_color
                font.family: "Hack"
                font.bold: true
                font.pointSize: font_size
                wrapMode: Text.WrapAnywhere
            }

            TextField{
                x: control_spacing
                color: font_color
                text: product_comment
                width: parent.width-control_spacing*2
                selectByMouse: true
                onTextChanged: product_comment = text
            }



            Rectangle{
                x:control_spacing
                width: id_button.width+control_spacing*2
                height: id_button.implicitHeight+control_spacing*2
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
                    text: "Save"
                    color: font_color
                    font.family: "Hack"
                    font.bold: true
                    font.pointSize: font_size
                    wrapMode: Text.WrapAnywhere
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        setCommentsJSON();
                    }
                }

            }


        }
    }

    Component.onCompleted: {
        init()
    }

    function init(){
        product_report_address = "";
        product_comment = "";
        getCommentsJSON();
    }

    function setCommentsJSON(){


        var xhr = new XMLHttpRequest();
        xhr.open("POST", host+'/comments', true);
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
                                    comment: product_comment,
                                    address: product_report_address
                                }));
    }

    function getCommentsJSON() {
        var request = new XMLHttpRequest()

        var uri = host+'/comments?';
        uri += 'cluster_issue='+encodeURIComponent(selected_initiative_epic);
        uri += '&product='+encodeURIComponent(selected_product);

        request.open('GET', uri, true);
        request.setRequestHeader("Authorization", identity);
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {

                    var result = JSON.parse(request.responseText)

                    product_report_address = result.address;
                    product_comment = result.comment;

                } else {
                    console.log("HTTP:", request.status, request.statusText)
                }
            }

        }
        request.send()
    }

}
