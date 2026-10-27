import QtQuick
import QtQuick.Controls

Item {
    id: root

    property int currentIndex: 0
    property var answers: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    signal completed(var answersList, int totalScore)

    implicitWidth: 780
    implicitHeight: 560

    focus: true
    Keys.onDigit1Pressed: root.selectRating(1)
    Keys.onDigit2Pressed: root.selectRating(2)
    Keys.onDigit3Pressed: root.selectRating(3)
    Keys.onDigit4Pressed: root.selectRating(4)
    Keys.onDigit5Pressed: root.selectRating(5)
    Keys.onLeftPressed: if (root.currentIndex > 0) root.currentIndex--

    property var currentItemData: vviqEngine.getItem(root.currentIndex)

    function selectRating(score) {
        var copy = answers.slice();
        copy[root.currentIndex] = score;
        root.answers = copy;

        if (root.currentIndex < 15) {
            root.currentIndex++;
        } else {
            // Compute total score
            var total = 0;
            for (var i = 0; i < 16; ++i) {
                total += root.answers[i];
            }
            root.completed(root.answers, total);
        }
    }

    Column {
        anchors.fill: parent
        spacing: 16

        // Progress bar & Scenario indicator
        Row {
            width: parent.width
            spacing: 12

            Column {
                width: parent.width - 120
                spacing: 6

                Row {
                    spacing: 8
                    Text {
                        text: qsTr("Question %1 of 16").arg(root.currentIndex + 1)
                        color: Theme.textPrimary
                        font.pixelSize: Theme.fontMd
                        font.bold: true
                    }
                    Text {
                        text: "• " + root.currentItemData.scenarioTitle
                        color: Theme.primaryLight
                        font.pixelSize: Theme.fontSm
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 6
                    radius: 3
                    color: Theme.borderDim

                    Rectangle {
                        height: parent.height
                        radius: 3
                        width: parent.width * ((root.currentIndex + 1) / 16.0)
                        color: Theme.primary

                        Behavior on width {
                            NumberAnimation { duration: 200 }
                        }
                    }
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("%1% Completed").arg(Math.round(((root.currentIndex + 1) / 16.0) * 100))
                color: Theme.textMuted
                font.pixelSize: Theme.fontXs
            }
        }

        // Scenario Context Card
        Rectangle {
            width: parent.width
            height: scenarioCol.height + 24
            color: Theme.bgCard
            radius: Theme.radiusMd
            border.color: Theme.borderMedium
            border.width: 1

            Column {
                id: scenarioCol
                anchors.top: parent.top
                anchors.topMargin: 12
                anchors.left: parent.left
                anchors.leftMargin: 16
                width: parent.width - 32
                spacing: 6

                Row {
                    spacing: 8
                    Text {
                        text: "👁"
                        font.pixelSize: 14
                    }
                    Text {
                        text: root.currentItemData.scenarioTitle
                        color: Theme.textPrimary
                        font.pixelSize: Theme.fontSm
                        font.bold: true
                    }
                }

                Text {
                    text: root.currentItemData.scenarioDescription
                    color: Theme.textSecondary
                    font.pixelSize: Theme.fontXs
                    font.italic: true
                    wrapMode: Text.WordWrap
                    width: parent.width
                    lineHeight: 1.3
                }
            }
        }

        // Current Question Item Card
        Rectangle {
            width: parent.width
            height: 90
            color: Theme.bgCardElevated
            radius: Theme.radiusMd
            border.color: Theme.primary
            border.width: 1

            Row {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16

                Rectangle {
                    width: 38
                    height: 38
                    radius: 19
                    color: Theme.primary
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: (root.currentIndex + 1).toString()
                        color: "#FFFFFF"
                        font.bold: true
                        font.pixelSize: Theme.fontMd
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.currentItemData.text
                    color: Theme.textPrimary
                    font.pixelSize: Theme.fontLg
                    font.weight: Font.Medium
                    wrapMode: Text.WordWrap
                    width: parent.width - 60
                }
            }
        }

        // Rating Scale Option Buttons (1 to 5)
        Text {
            text: qsTr("Rate the vividness of the image in your mind's eye:")
            color: Theme.textSecondary
            font.pixelSize: Theme.fontSm
            font.bold: true
        }

        Column {
            width: parent.width
            spacing: 8

            Repeater {
                model: [1, 2, 3, 4, 5]

                Rectangle {
                    id: ratingBtn
                    required property int modelData
                    readonly property int scoreVal: modelData
                    width: parent.width
                    height: 52
                    radius: Theme.radiusMd
                    property bool isPicked: (root.answers[root.currentIndex] === scoreVal)
                    color: isPicked ? Theme.bgCardElevated : Theme.bgCard
                    border.color: ratingBtn.activeFocus ? Theme.focusRing : (isPicked ? Theme.primary : Theme.borderMedium)
                    border.width: ratingBtn.activeFocus ? 2 : (isPicked ? 2 : 1)
                    activeFocusOnTab: true
                    Accessible.role: Accessible.RadioButton
                    Accessible.name: vviqEngine.getRatingLabel(scoreVal)

                    Keys.onReturnPressed: root.selectRating(scoreVal)
                    Keys.onSpacePressed: root.selectRating(scoreVal)

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            ratingBtn.forceActiveFocus();
                            root.selectRating(ratingBtn.scoreVal);
                        }
                    }

                    Row {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 16

                        Rectangle {
                            width: 26
                            height: 26
                            radius: 13
                            color: ratingBtn.isPicked ? Theme.primary : Theme.bgInput
                            border.color: Theme.borderBright
                            border.width: 1
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: ratingBtn.scoreVal.toString()
                                color: ratingBtn.isPicked ? "#FFFFFF" : Theme.textSecondary
                                font.bold: true
                                font.pixelSize: Theme.fontSm
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2

                            Text {
                                text: vviqEngine.getRatingLabel(ratingBtn.scoreVal)
                                color: ratingBtn.isPicked ? Theme.primaryLight : Theme.textPrimary
                                font.pixelSize: Theme.fontSm
                                font.bold: true
                            }

                            Text {
                                text: vviqEngine.getRatingDescription(ratingBtn.scoreVal)
                                color: Theme.textSecondary
                                font.pixelSize: Theme.fontXs
                            }
                        }
                    }
                }
            }
        }

        // Bottom Navigation Buttons & Accessibility Shortcut Hint
        Row {
            width: parent.width
            spacing: 16

            Button {
                id: prevBtn
                text: qsTr("← Previous Item")
                enabled: root.currentIndex > 0
                onClicked: root.currentIndex--
                activeFocusOnTab: true
                Keys.onReturnPressed: clicked()
                Keys.onSpacePressed: clicked()
                Accessible.role: Accessible.Button
                Accessible.name: text

                background: Rectangle {
                    color: prevBtn.down ? Theme.bgCardElevated : (prevBtn.hovered ? Theme.bgCardElevated : Theme.bgCard)
                    border.color: prevBtn.activeFocus ? Theme.focusRing : Theme.borderMedium
                    border.width: prevBtn.activeFocus ? 2 : 1
                    radius: Theme.radiusMd
                    implicitHeight: 40
                    implicitWidth: 160
                    opacity: prevBtn.enabled ? 1.0 : 0.4
                }
                contentItem: Text {
                    text: prevBtn.text
                    color: prevBtn.enabled ? Theme.textPrimary : Theme.textMuted
                    font.pixelSize: Theme.fontSm
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Shortcut: Press 1-5 to rate • Left Arrow for previous")
                color: Theme.textMuted
                font.pixelSize: Theme.fontXs
            }
        }
    }
}
