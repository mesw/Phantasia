import QtQuick
import QtQuick.Controls

Item {
    id: root

    property var scores: ({
        "auditory": 3,
        "tactile": 3,
        "kinesthetic": 3,
        "olfactory": 3,
        "gustatory": 3,
        "emotional": 3
    })

    signal completed(var psiqScores)

    implicitWidth: 780
    implicitHeight: 640

    property var modalities: vviqEngine.getMultisensoryModalityList()

    function setScore(key, val) {
        var copy = Object.assign({}, root.scores);
        copy[key] = val;
        root.scores = copy;
    }

    Column {
        anchors.fill: parent
        spacing: 16

        // Header info
        Rectangle {
            width: parent.width
            height: 70
            color: Theme.bgCard
            radius: Theme.radiusMd
            border.color: Theme.borderMedium
            border.width: 1

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: Theme.accent
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "🌐"
                        font.pixelSize: 18
                    }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    Text {
                        text: qsTr("Step 3: Multi-Sensory Profiling (Dawes et al. 2024)")
                        color: Theme.textPrimary
                        font.pixelSize: Theme.fontMd
                        font.bold: true
                    }

                    Text {
                        text: qsTr("Assessing non-visual modalities to identify whether aphantasia is unimodal (visual-only) or multisensory.")
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontXs
                    }
                }
            }
        }

        // Modality List
        Flickable {
            width: parent.width
            height: parent.height - 150
            contentWidth: width
            contentHeight: modListCol.height + 20
            clip: true

            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

            Column {
                id: modListCol
                width: parent.width
                spacing: 12

                Repeater {
                    model: root.modalities

                    Rectangle {
                        id: modCard
                        required property var modelData
                        readonly property string modKey: modelData.key
                        readonly property string modName: modelData.name
                        readonly property string modPrompt: modelData.prompt

                        width: parent.width
                        height: 76
                        radius: Theme.radiusMd
                        color: Theme.bgCardElevated
                        border.color: Theme.borderMedium
                        border.width: 1

                        Row {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 16

                            Column {
                                width: parent.width - 250
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 4

                                Text {
                                    text: modCard.modName
                                    color: Theme.textPrimary
                                    font.pixelSize: Theme.fontSm
                                    font.bold: true
                                }

                                Text {
                                    text: modCard.modPrompt
                                    color: Theme.textSecondary
                                    font.pixelSize: Theme.fontXs
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                }
                            }

                            // 1 to 5 rating buttons
                            Row {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 6

                                Repeater {
                                    model: [1, 2, 3, 4, 5]

                                    Rectangle {
                                        id: scoreBtn
                                        required property int modelData
                                        readonly property int scoreVal: modelData
                                        readonly property bool isCurrent: (root.scores[modCard.modKey] === scoreVal)

                                        width: 38
                                        height: 38
                                        radius: Theme.radiusSm
                                        color: isCurrent ? Theme.primary : Theme.bgInput
                                        border.color: scoreBtn.activeFocus ? Theme.focusRing : (isCurrent ? Theme.primaryLight : Theme.borderMedium)
                                        border.width: scoreBtn.activeFocus ? 2 : 1
                                        activeFocusOnTab: true

                                        Keys.onReturnPressed: root.setScore(modCard.modKey, scoreVal)
                                        Keys.onSpacePressed: root.setScore(modCard.modKey, scoreVal)

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                scoreBtn.forceActiveFocus();
                                                root.setScore(modCard.modKey, scoreBtn.scoreVal);
                                            }
                                        }

                                        Text {
                                            anchors.centerIn: parent
                                            text: scoreBtn.scoreVal.toString()
                                            color: scoreBtn.isCurrent ? "#FFFFFF" : Theme.textSecondary
                                            font.bold: scoreBtn.isCurrent
                                            font.pixelSize: Theme.fontSm
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Submit Button
        Button {
            id: submitBtn
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Generate Diagnostic Report & Baseline Profile →")
            onClicked: root.completed(root.scores)
            activeFocusOnTab: true
            Keys.onReturnPressed: clicked()
            Keys.onSpacePressed: clicked()
            Accessible.role: Accessible.Button
            Accessible.name: text

            background: Rectangle {
                color: submitBtn.down ? Theme.primaryHover : (submitBtn.hovered ? Theme.primaryLight : Theme.primary)
                border.color: submitBtn.activeFocus ? Theme.focusRing : Theme.primaryGlow
                border.width: submitBtn.activeFocus ? 2 : 1
                radius: Theme.radiusMd
                implicitHeight: 46
                implicitWidth: 380
            }
            contentItem: Text {
                text: submitBtn.text
                color: "#FFFFFF"
                font.pixelSize: Theme.fontSm
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
