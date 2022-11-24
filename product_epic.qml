import QtQuick 2.9
import QtQuick.Controls 2.0

Page {
    id: page_id
    title: qsTr("Продукты "+selected_initiative+" кластера "+selected_cluster+" epic "+selected_issue)
    property string title_image: "images/settings.png"
    property bool saved: false

    Rectangle{
        anchors.fill: parent
        color: background_color
    }


    ListModel {
        id: product_model
    }

    Component {
        id: product_delegate
        Rectangle{
            width: page_id.width
            height: main_row.implicitHeight+control_spacing*2
            color: (name==selected_product)?(saved?"lightgreen":"darkgray"):"transparent"

            border{
                width: 1
                color: "lightgray"
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    saved = false
                    selected_product = name

                }
            }

            Row{
                x:control_spacing
                y:control_spacing
                spacing: control_spacing
                width: parent.width
                id:main_row

                Text {
                    id: id_issue
                    text: issue
                    width: 150
                    color: font_color
                    font.family: "Hack"
                    font.bold: false
                    font.pointSize: font_size
                    wrapMode: Text.WrapAnywhere
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


                Rectangle{
                    width: id_button.implicitWidth+control_spacing*2
                    height: id_button.implicitHeight+control_spacing*2
                    visible: (selected_product===name)
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
                        text: "Select Epic >>"
                        color: font_color
                        font.family: "Hack"
                        font.bold: true
                        font.pointSize: font_size
                        wrapMode: Text.WrapAnywhere
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            stack_view_push("epic.qml")
                        }
                    }

                }

                Rectangle{
                    width: id_button2.implicitWidth+control_spacing*2
                    height: id_button2.implicitHeight+control_spacing*2
                    visible: (selected_product===name)
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
                        text: "Comment >>"
                        color: font_color
                        font.family: "Hack"
                        font.bold: true
                        font.pointSize: font_size
                        wrapMode: Text.WrapAnywhere
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            stack_view_push("comments.qml")
                        }
                    }



                }

            }

        }

    }

    Column{
        width: parent.width
        height: parent.height
        y:control_spacing

        Rectangle{
            width: control_spacing
            height: control_spacing
            color: "transparent"
        }

        Flickable{

            width:page_id.width
            height:page_id.height-control_spacing*2
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
                    id: id_product_list
                    height: id_product_list.contentHeight
                    width: parent.width
                    model: product_model
                    delegate: product_delegate
                }




            }
        }

    }
    Component.onCompleted: {
        getProductsJSON()
    }

    function init(){
        product_model.clear()
        getProductsJSON()
    }


    function getProductsJSON() {
        var request = new XMLHttpRequest()

        var uri = host+'/products?';
        uri += 'cluster='+encodeURIComponent(selected_cluster);
        uri += '&cluster_issue='+encodeURIComponent(selected_initiative_epic);

        request.open('GET', uri, true);
        request.setRequestHeader("Authorization", identity);
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    console.log("response", request.responseText)
                    var result = JSON.parse(request.responseText)
                    var length = result.length;

                    for (var i = 0; i < length; i++){
                        product_model.append({"name":result[i].name,"issue":result[i].issue})
                    }

                } else {
                    console.log("HTTP:", request.status, request.statusText)
                }
            }

        }
        request.send()
    }
}
