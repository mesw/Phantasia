import QtQuick
import QtQuick.Controls

Item {
    id: root

    property int currentIndex: 0
    property var answers: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    signal completed(var answersList, int totalScore)

    implicitWidth: 780
    implicitHeight: 560

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
                    width: parent.width
                    height: 52
                    radius: Theme.radiusMd
                    property bool isPicked: (root.answers[root.currentIndex] === modelData)
                    color: isPicked ? Theme.bgCardElevated : Theme.bgCard
                    border.color: isPicked ? Theme.primary : Theme.borderMedium
                    border.width: isPicked ? 2 : 1

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.selectRating(modelData);
                        }
                        onEntered: {
                            if (!ratingBtn.isPicked) {
                                ratingBtn.border.color = Theme.borderBright;
                            }
                        }
                        onExited: {
                            if (!ratingBtn.isPicked) {
                                ratingBtn.border.color = Theme.borderMedium;
                            }
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
                                text: modelData.toString()
                                color: ratingBtn.isPicked ? "#FFFFFF" : Theme.textSecondary
                                font.bold: true
                                font.pixelSize: Theme.fontSm
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2

                            Text {
                                text: vviqEngine.getRatingLabel(modelData)
                                color: ratingBtn.isPicked ? Theme.primaryLight : Theme.textPrimary
                                font.pixelSize: Theme.fontSm
                                font.bold: true
                            }

                            Text {
                                text: vviqEngine.getRatingDescription(modelData)
                                color: Theme.textMuted
                                font.pixelSize: Theme.fontXs
                            }
                        }
                    }
                }
            }
        }

        // Bottom Navigation Buttons
        Row {
            width: parent.width
            spacing: 12

            Button {
                text: qsTr("Previous Item")
                enabled: root.currentIndex > 0
                onClicked: root.currentIndex--
                background: Rectangle {
                    color: Theme.bgCard
                    border.color: Theme.borderMedium
                    radius: Theme.radiusMd
                    implicitHeight: 38
                    implicitWidth: 140
                    opacity: parent.enabled ? 1.0 : 0.4
                }
                contentItem: Text {
                    text: parent.text
                    color: parent.enabled ? Theme.textPrimary : Theme.textMuted
                    font.pixelSize: Theme.fontSm
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
