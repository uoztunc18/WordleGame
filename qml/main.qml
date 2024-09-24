import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.12

Window {
    id: mainWindow
    visible: true
    width: 800
    height: 900
    title: qsTr("WorldleGame")
    color: "#131313"

    // Dynamic string to store current typed letter
    property string wordInput: ""
    // Keep the guessed and checked words, and their corresponding colors
    property var guessList: []
    property var guessColors: []

    // Coloring of the letter boxes on the display board
    function getColor(wordIndex, letterIndex) {
        if (wordIndex < classA.guessCount) {
            // GuessCount != 0 => TypeError
            return guessColors[wordIndex][letterIndex]
        } else {
            return "#131313"
        }
    }

    // Getting letters of the boxes on the display board
    function getLetter(wordIndex, letterIndex) {
        if (wordIndex < classA.guessCount) {
            // Guesscount != 0 => TypeError
            return guessList[wordIndex][letterIndex];
        } else if (wordIndex === classA.guessCount) {
            return wordInput[letterIndex]
        } else {
            return ""
        }
    }

    Column {
        id: display
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: (parent.height-height-keyboard.height-30)/2
        }
        spacing: 5

        Repeater {
            model: 6

            Row {
                id: row
                spacing: 5

                property int rowIndex: index

                Repeater {
                    model: 5

                    Rectangle {
                        width: 60
                        height: 60
                        color: getColor(rowIndex, index)
                        border.color: "#3c3c3c"
                        border.width: 2

                        Text {
                            id: letter
                            text: getLetter(rowIndex, index) ? getLetter(rowIndex, index) : ""
                            color: "WHITE"
                            anchors.centerIn: parent
                            font.bold: true
                            font.pixelSize: 30
                        }
                    }
                }
            }
        }
    }

    Keyboard {
        id: keyboard
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 30
        }
    }

    // Popup boxes for corresponding errors
    Popup {
            id: errorPopup
            x: parent.width / 2 - width / 2
            y: 50
            width: 120
            height: 50
            visible: false
            modal: true
            background: Rectangle {
                    color: "lightgray"
                    radius: 4
            }

            property string message: ""

            Text {
                anchors.centerIn: parent
                text: errorPopup.message
                font.bold: true
                font.pixelSize: 10
            }

            Timer {
                id: errorPopupTimer
                interval: 1000
                repeat: false
                onTriggered: errorPopup.close()
            }
    }

    // Popup box after the game ends
    Popup {
        id: resetPopup
        x: parent.width / 2 - width / 2
        y: 50
        width: 150
        height: 60
        visible: classA.isGameOver
        modal: false
        background: Rectangle {
                color: "lightgray"
                radius: 4
        }

        Rectangle {
            id: resetButton
            width: parent.width
            height: parent.height/2
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: classA.won ? "#618c55" : "DARKRED"
            border.color: "#999999"
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "Reset"
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    guessList = [];
                    guessColors = [];
                    classA.resetGame();
                }
            }
        }

        Text {
            height: parent.height/2
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: classA.won ? "CONGRATULATIONS!" : "Word is " + classA.targetWord
            font.bold: true
        }
    }

    /*

    TODO: Animation

    Rectangle {
        width: 200
        height: 200
        radius: 3
        color: "orange"
        Flipable {
            id: flipable
            anchors.centerIn: parent
            property bool flipped: false

            front:  Rectangle {
                width: 100
                height: 100
                color: "DARKRED"
                anchors.centerIn: parent
            }

            back: Rectangle {
                width: 100
                height: 100
                color: "GREEN"
                anchors.centerIn: parent
            }

            transform : Rotation {
                axis.x : 1
                axis.y : 0
                axis.z : 0
                angle: flipable.flipped ? 180 : 0

                Behavior on angle {
                    NumberAnimation {duration: 500}
                }
            }

        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("MMTU");
                flipable.flipped = !flipable.flipped;
            }
        }
    }*/
}
