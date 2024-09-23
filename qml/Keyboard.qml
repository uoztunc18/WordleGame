import QtQuick 2.14

Column {
    spacing: 9

    function getColor(letter) {
        if (classA.greenLetters.indexOf(letter) !== -1) {
            return "#618c55"
        } else if (classA.yellowLetters.indexOf(letter) !== -1) {
            return "#b1a04c"
        } else if (classA.checkedLetters.indexOf(letter) !== -1) {
            return "#3c3c3c"
        } else {
            return "#818384"
        }
    }

    function validateGuess(guess) {
        console.log(guess);
        if (guess.length < 5) {
            missingLetterPopup.open()
            missingLetterPopupTimer.start();
        } else {
            if (classA.isGuessValid(guess)) {
                guessList.push(guess);
                const response = classA.isGuessCorrect(guess);
                const colors = []
                for (let i = 0; i<5 ;i++) {
                    switch (response.charAt(i)) {
                        case ('b'):
                            colors.push("#3c3c3c")
                            break
                        case ('y'):
                            colors.push("#b1a04c")
                            break
                        default:
                            colors.push("#618c55")
                            break
                    };
                };
                guessColors.push(colors)
                wordInput = "";
            } else {
                invalidWordPopup.open()
                invalidWordPopupTimer.start();
            }
        }
    }

    Row {
        id: qwer
        spacing: 6

        Repeater {
            model: ["Q","W","E","R","T","Y","U","I","O","P"]

            Rectangle {
                width: 45
                height: 60
                radius: 3
                color: getColor(modelData)

                property string text: modelData

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
        }
    }

    Row {
        id: asdf
        spacing: 6
        anchors.horizontalCenter: parent.horizontalCenter

        Repeater {
            model: ["A","S","D","F","G","H","J","K","L"]

            Rectangle {
                width: 45
                height: 60
                radius: 3
                color: getColor(modelData)

                property string text: modelData

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
        }
    }

    Row {
        id: zxcv
        spacing: 6
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: enter
            width: 60
            height: 60
            radius: 3
            color: "#818384"

            Text {
                anchors.centerIn: parent
                text: "ENTER"
                color: "WHITE"
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: validateGuess(wordInput)
            }
        }

        Repeater {
            model: ["Z","X","C","V","B","N","M"]

            Rectangle {
                width: 45
                height: 60
                radius: 3
                color: getColor(modelData)

                property string text: modelData

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
        }

        Rectangle {
            id: backspace

            width: 60
            height: 60
            radius: 3
            color: "#818384"

            Image {
                width: 20
                height: 25
                source: "backspaceIcon.png"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    wordInput = wordInput.substring(0, wordInput.length - 1);
                }
            }
        }
    }

    Item {
        id: keystrokes
        focus: true

        Keys.onPressed: (event)=> {
                            if (event.key === Qt.Key_Backspace) {
                                wordInput = wordInput.substring(0, wordInput.length - 1);
                                return;
                            }

                            if (isGuessLengthAllowed) {
                                const keyCode = event.text;
                                if ((keyCode >= "A" && keyCode <= "Z") || (keyCode >= "a" && keyCode <= "z")) {
                                    wordInput += keyCode.toUpperCase()
                                    event.accepted = true;
                                    console.log(wordInput)
                                }
                                return;
                            }
        }

        Keys.onReturnPressed: (event) => validateGuess(wordInput)
    }
}
