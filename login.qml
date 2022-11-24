import QtQuick 2.9
import QtQuick.Controls 2.0

Page {
    id: page_id
    title: qsTr("Настройки")
    property string title_image: "images/settings.png"





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
                text: "Адрес сервера"
                color: font_color
                font.family: "Hack"
                font.bold: true
                font.pointSize: font_size
                wrapMode: Text.WrapAnywhere
            }

            TextField{
                x: control_spacing
                text: host
                color: font_color
                width: parent.width-control_spacing*2
                selectByMouse: true
                onTextChanged: host = text
            }

            Rectangle{
                width: control_spacing
                height: control_spacing
                color: "transparent"
            }

            Text {
                x:control_spacing
                text: "User name"
                color: font_color
                font.family: "Hack"
                font.bold: true
                font.pointSize: font_size
                wrapMode: Text.WrapAnywhere
            }

            TextField{
                x: control_spacing
                color: font_color
                text: user
                width: parent.width-control_spacing*2
                selectByMouse: true
                onTextChanged: user = text
            }

            Rectangle{
                width: control_spacing
                height: control_spacing
                color: "transparent"
            }

            Text {
                x:control_spacing
                text: "Password"
                color: font_color
                font.family: "Hack"
                font.bold: true
                font.pointSize: font_size
                wrapMode: Text.WrapAnywhere
            }

            TextField{
                x: control_spacing
                text: password
                width: parent.width-control_spacing*2
                color: font_color
                echoMode: TextInput.Password
                selectByMouse: true
                onTextChanged: password = text
            }

            Rectangle{
                width: control_spacing
                height: control_spacing
                color: "transparent"
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
                    text: "Login >>"
                    color: font_color
                    font.family: "Hack"
                    font.bold: true
                    font.pointSize: font_size
                    wrapMode: Text.WrapAnywhere
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        identity = "Basic "+encode64(user+":"+password);
                        stack_view_push("Initiatives.qml")
                    }
                }

            }


        }
    }

    function init(){

    }

    function encode64(input) {
        var _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
        var output = "";
        var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
        var i = 0;

        input = utf8_encode(input);

        while (i < input.length) {

            chr1 = input.charCodeAt(i++);
            chr2 = input.charCodeAt(i++);
            chr3 = input.charCodeAt(i++);

            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
            enc4 = chr3 & 63;

            if (isNaN(chr2)) {
                enc3 = enc4 = 64;
            } else if (isNaN(chr3)) {
                enc4 = 64;
            }

            output = output +
                    _keyStr.charAt(enc1) + _keyStr.charAt(enc2) +
                    _keyStr.charAt(enc3) + _keyStr.charAt(enc4);
        }
        return output;
    }
    // private method for UTF-8 encoding
    function utf8_encode(string) {
        string = string.replace(/\r\n/g,"\n");
        var utftext = "";

        for (var n = 0; n < string.length; n++) {

            var c = string.charCodeAt(n);

            if (c < 128) {
                utftext += String.fromCharCode(c);
            }
            else if((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            }
            else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }
        }
        return utftext;

    }
}
