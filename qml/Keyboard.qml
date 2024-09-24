import QtQuick 2.14

Column {
    spacing: 9

    function backspaceKeyHandler() {
        wordInput = wordInput.substring(0, wordInput.length - 1);
        console.log(wordInput)
    }

    function letterKeyHandler(keyCode) {
        if ((keyCode >= "A" && keyCode <= "Z") || (keyCode >= "a" && keyCode <= "z")) {
            wordInput += keyCode.toUpperCase()
            console.log(wordInput)
        }
    }

    // Coloring of the keyboard
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

    function errorHandler(message) {
        errorPopup.message = message
        errorPopup.open()
        if (errorPopupTimer.running) {
            errorPopupTimer.stop()
        }
        errorPopupTimer.start();
    }

    //Handling the word that is found in word list, to be checked and updating color tables
    function validateGuess(guess) {
        if (guess.length < 5) {
            errorHandler("Not enough letters")
            return
        }

        if (classA.isGuessValid(guess)) {
            wordInput = "";
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
            classA.guessCountChanged()
        } else {
            errorHandler("Not in word list")
        }
    }

    Row {
        id: qwer
        spacing: 6

        Repeater {
            model: ["Q","W","E","R","T","Y","U","I","O","P"]

            Key {
                color: getColor(modelData)
                text: modelData
            }
        }
    }

    Row {
        id: asdf
        spacing: 6
        anchors.horizontalCenter: parent.horizontalCenter

        Repeater {
            model: ["A","S","D","F","G","H","J","K","L"]

            Key {
                color: getColor(modelData)
                text: modelData
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

            Key {
                color: getColor(modelData)
                text: modelData
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
                onClicked: backspaceKeyHandler()
            }
        }
    }

    Item {
        id: keystrokes
        focus: true
        enabled: !classA.isGameOver

        Keys.onPressed: (event)=> {
                            if (event.key === Qt.Key_Backspace) {
                                backspaceKeyHandler();
                                event.accepted = true
                                return;
                            }

                            if (wordInput.length < 5) {
                                letterKeyHandler(event.text)
                                event.accepted = true
                                return;
                            }
        }

        Keys.onReturnPressed: (event) => validateGuess(wordInput)
    }
}
