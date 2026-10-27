import QtQuick
import QtQuick.Controls

Item {
    id: root

    implicitWidth: 840
    implicitHeight: 380

    property var trainingHistory: storageManager.getTrainingHistory()
    property var assessmentHistory: storageManager.getAssessmentHistory()

    Rectangle {
        anchors.fill: parent
        color: Theme.bgCard
        radius: Theme.radiusMd
        border.color: Theme.borderMedium
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16

            Row {
                width: parent.width
                spacing: 12

                Text {
                    text: qsTr("Training Ratings & Adherence Timeline")
                    color: Theme.textPrimary
                    font.pixelSize: Theme.fontMd
                    font.bold: true
                }

                Item { width: Math.max(10, parent.width - 480); height: 1 }

                Text {
                    text: qsTr("Total Logged: %1 micro-sessions").arg(root.trainingHistory.length)
                    color: Theme.textMuted
                    font.pixelSize: Theme.fontXs
                }
            }

            // Visual bar chart of session ratings
            Rectangle {
                width: parent.width
                height: 190
                color: Theme.bgInput
                radius: Theme.radiusSm
                border.color: Theme.borderDim
                border.width: 1

                Item {
                    anchors.fill: parent
                    anchors.margins: 14
                    visible: root.trainingHistory.length > 0

                    Flickable {
                        anchors.fill: parent
                        contentWidth: Math.max(width, root.trainingHistory.length * 36 + 20)
                        contentHeight: height
                        clip: true

                        ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AsNeeded }

                        Row {
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 24
                            spacing: 12

                            Repeater {
                                model: root.trainingHistory

                                Column {
                                    spacing: 4
                                    anchors.bottom: parent.bottom

                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: (modelData.rating || 0).toString()
                                        color: Theme.primaryLight
                                        font.pixelSize: 10
                                        font.bold: true
                                    }

                                    Rectangle {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: 22
                                        height: Math.max(10, (modelData.rating || 1) * 24)
                                        radius: 4
                                        color: {
                                            var r = modelData.rating || 1;
                                            if (r >= 4) return Theme.emerald;
                                            if (r === 3) return Theme.primary;
                                            return Theme.amber;
                                        }
                                    }

                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "W" + (modelData.week || 1) + "D" + (modelData.day || 1)
                                        color: Theme.textMuted
                                        font.pixelSize: 9
                                    }
                                }
                            }
                        }
                    }
                }

                // Empty state
                Column {
                    anchors.centerIn: parent
                    spacing: 8
                    visible: root.trainingHistory.length === 0

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "📊"
                        font.pixelSize: 28
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("No training sessions completed yet.")
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontSm
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Complete your first 15-minute session to begin longitudinal tracking.")
                        color: Theme.textMuted
                        font.pixelSize: Theme.fontXs
                    }
                }
            }

            // Summary Stats Row
            Row {
                width: parent.width
                spacing: 16

                Rectangle {
                    width: (parent.width - 32) / 3
                    height: 70
                    radius: Theme.radiusSm
                    color: Theme.bgCardElevated
                    border.color: Theme.borderDim
                    border.width: 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 2
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Baseline VVIQ")
                            color: Theme.textMuted
                            font.pixelSize: Theme.fontXs
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: storageManager.hasBaseline ? (storageManager.latestVviqScore + " / 80") : qsTr("Not taken")
                            color: Theme.textPrimary
                            font.pixelSize: Theme.fontLg
                            font.bold: true
                        }
                    }
                }

                Rectangle {
                    width: (parent.width - 32) / 3
                    height: 70
                    radius: Theme.radiusSm
                    color: Theme.bgCardElevated
                    border.color: Theme.borderDim
                    border.width: 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 2
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Current Curriculum Progress")
                            color: Theme.textMuted
                            font.pixelSize: Theme.fontXs
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Week %1, Day %2").arg(storageManager.currentWeek).arg(storageManager.currentDay)
                            color: Theme.cyanLight
                            font.pixelSize: Theme.fontLg
                            font.bold: true
                        }
                    }
                }

                Rectangle {
                    width: (parent.width - 32) / 3
                    height: 70
                    radius: Theme.radiusSm
                    color: Theme.bgCardElevated
                    border.color: Theme.borderDim
                    border.width: 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 2
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Adherence Streak")
                            color: Theme.textMuted
                            font.pixelSize: Theme.fontXs
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("%1 Days").arg(storageManager.trainingStreak)
                            color: Theme.emeraldLight
                            font.pixelSize: Theme.fontLg
                            font.bold: true
                        }
                    }
                }
            }
        }
    }
}
