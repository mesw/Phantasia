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
                                    text: modelData.name
                                    color: Theme.textPrimary
                                    font.pixelSize: Theme.fontSm
                                    font.bold: true
                                }

                                Text {
                                    text: modelData.prompt
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
                                        width: 38
                                        height: 38
                                        radius: Theme.radiusSm
                                        property bool isCurrent: (root.scores[modelData.key] === modelData)
                                        color: isCurrent ? Theme.primary : Theme.bgInput
                                        border.color: isCurrent ? Theme.primaryLight : Theme.borderMedium
                                        border.width: 1

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: root.setScore(modelData.key, modelData)
                                        }

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.toString()
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
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Generate Diagnostic Report & Baseline Profile →")
            onClicked: {
                root.completed(root.scores);
            }
            background: Rectangle {
                color: Theme.primary
                radius: Theme.radiusMd
                implicitHeight: 46
                implicitWidth: 380
            }
            contentItem: Text {
                text: parent.text
                color: "#FFFFFF"
                font.pixelSize: Theme.fontSm
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
