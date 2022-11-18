import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Window 2.0



ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("jreport")

    property int    image_size : 32
    property string background_color : "white"
    property string font_color : "black"
    property int    font_size: 10
    property int    border_margin :5
    property int    control_spacing: 10

    property string selected_initiative : ""
    property string selected_cluster : ""
    property string selected_initiative_epic : ""
    property string selected_product: ""
    property string selected_issue: ""

    property string host : "http://192.168.64.6"
    property string user : ""
    property string password : ""
    property string identity : ""


    function stack_view_push(item){
        stackView.push(item);

    }
    Connections{

    }

    header: ToolBar {
        contentHeight: toolButton.implicitHeight
        height:48

        Row{
            height:parent.height
            width: parent.width
            spacing: 10



            Rectangle {
                id: toolButton
                width:image_size
                height:image_size
                x:10
                y:10
                color: "transparent"
                Image{
                    id: icon_id
                    fillMode: Image.PreserveAspectFit
                    height: image_size
                    width: image_size
                    anchors.centerIn: parent
                    source: "images/icon.png"
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: drawer.open()
                }
            }
            Rectangle{
                color: "white"
                radius: 5
                border.width: 1
                x:10
                y:10
                width: image_size
                height: image_size
                visible: stackView.depth>1

                Image {
                    source: "images/back-arrow.png";
                    x:5
                    y:5
                    height: image_size-10
                    width: image_size-10
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {

                        if (stackView.depth>1) {

                            stackView.pop();
                            stackView.currentItem.init();
                        }

                    }
                }
            }

            Rectangle{
                height: parent.height
                width: title_label_id.implicitWidth
                color: "transparent"
                Label {
                    y: (parent.height-implicitHeight)/2
                    id:title_label_id
                    text: stackView.currentItem.title
                    font.pointSize: 14
                    font.family: "Hack"
                    font.bold: true
                }
            }

        }

    }

    Drawer {
        id: drawer
        width: 84
        height: window.height

        Column {
            anchors.fill: parent
            spacing: 10

            Rectangle{
                width:20
                height:20
                color: "transparent"
            }


            ItemDelegate {
                text: qsTr("")
                width: parent.width
                height: image_size

                background: Rectangle{ color: "transparent"}

                onClicked: {
                    while(stackView.depth>1) stackView.pop();
                    stack_view_push("statistics.qml")
                    drawer.close()
                }
                Image{
                    source: "images/pie-chart.png"
                    height: image_size
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                }

            }

            ItemDelegate {
                text: qsTr("")
                width: parent.width
                height: image_size
                background: Rectangle{ color: "transparent"}

                onClicked: {
                    while(stackView.depth>1) stackView.pop();
                    stack_view_push("export.qml")
                    drawer.close()
                }
                Image{
                    source: "images/export.png"
                    height: image_size
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                }
            }

            ItemDelegate {
                text: qsTr("")
                width: parent.width
                height: image_size
                background: Rectangle{ color: "transparent"}
                onClicked: {
                    while(stackView.depth>1) stackView.pop();
                    stack_view_push("edit_main.qml")
                    drawer.close()
                }
                Image{
                    source: "images/edit.png"
                    height: image_size
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                }
            }

            ItemDelegate {
                text: qsTr("")
                width: parent.width
                height: image_size
                background: Rectangle{ color: "transparent"}
                onClicked: {
                    while(stackView.depth>1) stackView.pop();
                    stack_view_push("settings.qml")
                    drawer.close()
                }
                Image{
                    source: "images/settings.png"
                    height: image_size
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                }
            }

        }
    }


    StackView {
        id: stackView
        initialItem: "login.qml"
        anchors.fill: parent

    }
}
