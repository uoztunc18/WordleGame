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

    property var guessList: []
    property string wordInput: ""
    property var guessColors: []
    property bool isGuessLengthAllowed: wordInput.length < 5

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
                        color: {
                            if (rowIndex < guessColors.length) {
                                guessColors[rowIndex][index] ? guessColors[rowIndex][index] : "";
                            } else if (rowIndex === guessColors.length) {
                                wordInput[index] ? "#131313" : "#131313"
                            } else {
                                wordInput[index] ? "#131313" : "#131313"
                            }
                        }

                        border.color: "#3c3c3c"
                        border.width: 2

                        Text {
                            id: letter
                            text: {
                                if (rowIndex < guessList.length) {
                                    guessList[rowIndex][index] ? guessList[rowIndex][index] : "";
                                } else if (rowIndex === guessList.length) {
                                    wordInput[index] ? wordInput[index] : ""
                                } else {
                                    wordInput[index] ? "" : ""
                                }
                            }

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

    Popup {
            id: missingLetterPopup
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

            Text {
                anchors.centerIn: parent
                text: "Not enough letters"
                font.bold: true
                font.pixelSize: 10
            }

            Timer {
                id: missingLetterPopupTimer
                interval: 1000
                repeat: false
                onTriggered: missingLetterPopup.close()
            }
    }

    Popup {
            id: invalidWordPopup
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

            Text {
                anchors.centerIn: parent
                text: "Not in word list"
                font.bold: true
                font.pixelSize: 10
            }

            Timer {
                id: invalidWordPopupTimer
                interval: 1000
                repeat: false
                onTriggered: invalidWordPopup.close()
            }
    }

    /*
    Popup {
        id: resetPopup
        x: parent.width / 2 - width / 2
        y: 50
        width: 100
        height: 50
        visible: classA.isGameOver
        modal: false

        Rectangle {
            width: parent.width/2
            height: parent.height/2
            anchors.centerIn: parent
            color: "DARKRED"

            Text {
                anchors.centerIn: parent
                text: "Reset"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // console.log("BEFORE RESET "+classA.guessCount)
                    classA.resetGame();
                    // console.log("AFTER RESET "+classA.guessCount)
                }
            }
        }
    }*/

    /*Rectangle {
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
