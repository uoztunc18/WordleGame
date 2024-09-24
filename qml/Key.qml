import QtQuick 2.14

Rectangle {
    width: 45
    height: 60
    radius: 3

    property string text

    Text {
        anchors.centerIn: parent
        text: modelData
        color: "WHITE"
        font.bold: true
        font.pixelSize: 20
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (wordInput.length < 5) {
                wordInput += parent.text
            }
        }
    }
}
