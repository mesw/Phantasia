import QtQuick
import QtQuick.Controls

Item {
    id: root

    property int appleLevel: 5
    property int vviqScore: 16
    property var psiqScores: ({})
    property var itemAnswers: []

    signal startTrainingClicked()
    signal downloadReportClicked()
    signal retakeClicked()

    implicitWidth: 840
    implicitHeight: 700

    property string category: vviqEngine.classifyVviq(root.vviqScore)
    property string categoryCode: vviqEngine.classifyVviqCode(root.vviqScore)
    property string explanation: vviqEngine.classifyVviqExplanation(root.vviqScore)
    property double percentile: vviqEngine.calculatePercentile(root.vviqScore)
    property string multisensoryCat: vviqEngine.classifyMultisensory(root.vviqScore, root.psiqScores)
    property string multisensoryExpl: vviqEngine.classifyMultisensoryExplanation(root.vviqScore, root.psiqScores)

    readonly property color colorByCode: {
        if (categoryCode === "total_aphantasia" || categoryCode === "aphantasia") return Theme.rose;
        if (categoryCode === "hypophantasia") return Theme.amber;
        if (categoryCode === "typical") return Theme.emerald;
        return Theme.accent; // Hyperphantasia
    }

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: reportCol.height + 60
        clip: true

        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        Column {
            id: reportCol
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 40
            spacing: 20

            // Top Hero Card: Classification & Score
            Rectangle {
                width: parent.width
                height: 170
                radius: Theme.radiusLg
                color: Theme.bgCardElevated
                border.color: root.colorByCode
                border.width: 2

                Row {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 24

                    // Big Score Ring
                    Rectangle {
                        width: 120
                        height: 120
                        radius: 60
                        color: Theme.bgInput
                        border.color: root.colorByCode
                        border.width: 4
                        anchors.verticalCenter: parent.verticalCenter

                        Column {
                            anchors.centerIn: parent
                            spacing: 0

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: root.vviqScore.toString()
                                color: root.colorByCode
                                font.pixelSize: Theme.fontHuge
                                font.bold: true
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("out of 80")
                                color: Theme.textMuted
                                font.pixelSize: Theme.fontXs
                            }
                        }
                    }

                    // Classification Details
                    Column {
                        width: parent.width - 170
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 8

                        Row {
                            spacing: 10
                            Rectangle {
                                width: badgeText.width + 16
                                height: 26
                                radius: 13
                                color: root.colorByCode
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    id: badgeText
                                    anchors.centerIn: parent
                                    text: root.category
                                    color: "#FFFFFF"
                                    font.pixelSize: Theme.fontSm
                                    font.bold: true
                                }
                            }

                            Text {
                                text: qsTr("Percentile: %1%").arg(root.percentile)
                                color: Theme.cyanLight
                                font.pixelSize: Theme.fontSm
                                font.bold: true
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Text {
                            text: root.explanation
                            color: Theme.textPrimary
                            font.pixelSize: Theme.fontSm
                            wrapMode: Text.WordWrap
                            width: parent.width
                            lineHeight: 1.3
                        }
                    }
                }
            }

            // Multisensory Subtype Card (Dawes et al. 2024)
            Rectangle {
                width: parent.width
                height: multiCol.height + 28
                radius: Theme.radiusMd
                color: Theme.bgCard
                border.color: Theme.borderMedium
                border.width: 1

                Column {
                    id: multiCol
                    anchors.top: parent.top
                    anchors.topMargin: 14
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    width: parent.width - 40
                    spacing: 8

                    Row {
                        spacing: 10
                        Text {
                            text: "🧬"
                            font.pixelSize: 18
                        }
                        Text {
                            text: root.multisensoryCat
                            color: Theme.primaryLight
                            font.pixelSize: Theme.fontMd
                            font.bold: true
                        }
                    }

                    Text {
                        text: root.multisensoryExpl
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontSm
                        wrapMode: Text.WordWrap
                        width: parent.width
                        lineHeight: 1.3
                    }
                }
            }

            // Sensory Modalities Comparison Bar Chart
            Rectangle {
                width: parent.width
                height: 250
                radius: Theme.radiusMd
                color: Theme.bgCard
                border.color: Theme.borderMedium
                border.width: 1

                Column {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    Text {
                        text: qsTr("Cross-Sensory Modality Profile (Scale 1 to 5)")
                        color: Theme.textPrimary
                        font.pixelSize: Theme.fontSm
                        font.bold: true
                    }

                    // Modality Rows
                    Column {
                        width: parent.width
                        spacing: 8

                        Repeater {
                            model: [
                                { name: qsTr("Visual (VVIQ)"), val: (root.vviqScore / 16.0), col: root.colorByCode },
                                { name: qsTr("Auditory"), val: root.psiqScores["auditory"] || 3, col: Theme.cyan },
                                { name: qsTr("Tactile"), val: root.psiqScores["tactile"] || 3, col: Theme.emerald },
                                { name: qsTr("Kinesthetic"), val: root.psiqScores["kinesthetic"] || 3, col: Theme.amber },
                                { name: qsTr("Olfactory"), val: root.psiqScores["olfactory"] || 3, col: Theme.accent },
                                { name: qsTr("Gustatory"), val: root.psiqScores["gustatory"] || 3, col: Theme.rose },
                                { name: qsTr("Emotional"), val: root.psiqScores["emotional"] || 3, col: Theme.primaryLight }
                            ]

                            Row {
                                width: parent.width
                                spacing: 12

                                Text {
                                    text: modelData.name
                                    color: Theme.textSecondary
                                    font.pixelSize: Theme.fontXs
                                    width: 130
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Rectangle {
                                    width: parent.width - 190
                                    height: 12
                                    radius: 6
                                    color: Theme.bgInput
                                    anchors.verticalCenter: parent.verticalCenter

                                    Rectangle {
                                        height: parent.height
                                        radius: 6
                                        width: parent.width * (Math.min(5, Math.max(1, modelData.val)) / 5.0)
                                        color: modelData.col
                                    }
                                }

                                Text {
                                    text: modelData.val.toFixed(1) + " / 5"
                                    color: Theme.textPrimary
                                    font.pixelSize: Theme.fontXs
                                    font.bold: true
                                    width: 40
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                    }
                }
            }

            // Bottom Actions
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16

                Button {
                    id: startTrainingBtn
                    text: qsTr("Start 6-Week Functional Training →")
                    onClicked: root.startTrainingClicked()
                    activeFocusOnTab: true
                    Keys.onReturnPressed: clicked()
                    Keys.onSpacePressed: clicked()
                    Accessible.role: Accessible.Button
                    Accessible.name: text

                    background: Rectangle {
                        color: startTrainingBtn.down ? Theme.primaryHover : (startTrainingBtn.hovered ? Theme.primaryLight : Theme.primary)
                        border.color: startTrainingBtn.activeFocus ? Theme.focusRing : Theme.primaryGlow
                        border.width: startTrainingBtn.activeFocus ? 2 : 1
                        radius: Theme.radiusMd
                        implicitHeight: 46
                        implicitWidth: 320
                    }
                    contentItem: Text {
                        text: startTrainingBtn.text
                        color: "#FFFFFF"
                        font.pixelSize: Theme.fontSm
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Button {
                    id: downloadReportBtn
                    text: qsTr("Download Participant Data")
                    onClicked: root.downloadReportClicked()
                    activeFocusOnTab: true
                    Keys.onReturnPressed: clicked()
                    Keys.onSpacePressed: clicked()
                    Accessible.role: Accessible.Button
                    Accessible.name: text

                    background: Rectangle {
                        color: downloadReportBtn.hovered ? Theme.bgCardElevated : Theme.bgInput
                        border.color: downloadReportBtn.activeFocus ? Theme.focusRing : Theme.borderBright
                        border.width: downloadReportBtn.activeFocus ? 2 : 1
                        radius: Theme.radiusMd
                        implicitHeight: 46
                        implicitWidth: 220
                    }
                    contentItem: Row {
                        anchors.centerIn: parent
                        spacing: 6
                        Text {
                            text: "💾"
                            font.pixelSize: 13
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: downloadReportBtn.text
                            color: Theme.textPrimary
                            font.pixelSize: Theme.fontSm
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                Button {
                    id: retakeBtn
                    text: qsTr("Retake Test")
                    onClicked: root.retakeClicked()
                    activeFocusOnTab: true
                    Keys.onReturnPressed: clicked()
                    Keys.onSpacePressed: clicked()
                    Accessible.role: Accessible.Button
                    Accessible.name: text

                    background: Rectangle {
                        color: retakeBtn.hovered ? Theme.bgCardElevated : Theme.bgCard
                        border.color: retakeBtn.activeFocus ? Theme.focusRing : Theme.borderMedium
                        border.width: retakeBtn.activeFocus ? 2 : 1
                        radius: Theme.radiusMd
                        implicitHeight: 46
                        implicitWidth: 140
                    }
                    contentItem: Text {
                        text: retakeBtn.text
                        color: Theme.textPrimary
                        font.pixelSize: Theme.fontSm
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
}
