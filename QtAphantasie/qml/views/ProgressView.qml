import QtQuick
import QtQuick.Controls
import "../components"

Item {
    id: root

    signal downloadDataRequested()

    Column {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        // Header
        Row {
            width: parent.width
            spacing: 16

            Column {
                width: parent.width - 200
                spacing: 2

                Text {
                    text: qsTr("Longitudinal Progress & Training Metrics")
                    color: Theme.textPrimary
                    font.pixelSize: Theme.fontLg
                    font.bold: true
                }

                Text {
                    text: qsTr("Track your mental imagery trajectory, daily micro-session ratings, and baseline comparison.")
                    color: Theme.textSecondary
                    font.pixelSize: Theme.fontXs
                }
            }

            Button {
                text: qsTr("Export Data")
                onClicked: root.downloadDataRequested()
                background: Rectangle {
                    color: Theme.primary
                    radius: Theme.radiusMd
                    implicitHeight: 38
                    implicitWidth: 140
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

        // Main Chart Component
        ProgressChart {
            width: parent.width
            height: 340
        }

        // Assessment History Table
        Rectangle {
            width: parent.width
            height: parent.height - 430
            radius: Theme.radiusMd
            color: Theme.bgCard
            border.color: Theme.borderMedium
            border.width: 1

            Column {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                Text {
                    text: qsTr("Standardized Evaluation Log (VVIQ & Apple Test)")
                    color: Theme.textPrimary
                    font.pixelSize: Theme.fontSm
                    font.bold: true
                }

                Flickable {
                    width: parent.width
                    height: parent.height - 40
                    contentWidth: width
                    contentHeight: assessListCol.height
                    clip: true

                    ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                    Column {
                        id: assessListCol
                        width: parent.width
                        spacing: 8

                        Repeater {
                            model: storageManager.getAssessmentHistory()

                            Rectangle {
                                width: parent.width
                                height: 48
                                radius: Theme.radiusSm
                                color: Theme.bgInput
                                border.color: Theme.borderDim
                                border.width: 1

                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 16

                                    Text {
                                        text: (modelData.timestamp || "").substring(0, 10)
                                        color: Theme.textMuted
                                        font.pixelSize: Theme.fontXs
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Text {
                                        text: qsTr("Apple Test: Level %1").arg(modelData.appleLevel || 5)
                                        color: Theme.textSecondary
                                        font.pixelSize: Theme.fontXs
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Text {
                                        text: qsTr("VVIQ Score: %1 / 80").arg(modelData.vviqScore || 16)
                                        color: Theme.emeraldLight
                                        font.pixelSize: Theme.fontSm
                                        font.bold: true
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Rectangle {
                                        width: 80
                                        height: 20
                                        radius: 10
                                        color: Theme.bgCardElevated
                                        anchors.verticalCenter: parent.verticalCenter

                                        Text {
                                            anchors.centerIn: parent
                                            text: qsTr("%1% Rank").arg(modelData.percentile || 0.1)
                                            color: Theme.cyanLight
                                            font.pixelSize: 10
                                            font.bold: true
                                        }
                                    }

                                    Item { width: Math.max(10, parent.width - 550); height: 1 }

                                    Text {
                                        text: modelData.category || ""
                                        color: Theme.textPrimary
                                        font.pixelSize: Theme.fontXs
                                        font.bold: true
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                            }
                        }

                        // Empty notice
                        Text {
                            visible: storageManager.getAssessmentHistory().length === 0
                            text: qsTr("No baseline assessment recorded yet. Launch the Diagnostic tab to complete your initial evaluation.")
                            color: Theme.textMuted
                            font.pixelSize: Theme.fontXs
                            font.italic: true
                        }
                    }
                }
            }
        }
    }
}
