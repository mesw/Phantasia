import QtQuick
import QtQuick.Controls

Item {
    id: root

    signal launchSession(int week, int day)

    implicitWidth: 880
    implicitHeight: 700

    property var allWeeks: trainingEngine.getAllWeeks()

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: mainCol.height + 60
        clip: true

        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        Column {
            id: mainCol
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 40
            spacing: 20

            // Hero Banner: Progress & Today's Launch
            Rectangle {
                width: parent.width
                height: 140
                radius: Theme.radiusLg
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Theme.bgCardElevated }
                    GradientStop { position: 1.0; color: Theme.bgCard }
                }
                border.color: Theme.borderBright
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 20

                    // Left stats
                    Column {
                        width: parent.width - 280
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 8

                        Row {
                            spacing: 12
                            Text {
                                text: qsTr("6-Week Functional Imagery Training (FIT)")
                                color: Theme.textPrimary
                                font.pixelSize: Theme.fontLg
                                font.bold: true
                            }
                            Rectangle {
                                width: 70
                                height: 22
                                radius: 11
                                color: Theme.primary
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    anchors.centerIn: parent
                                    text: qsTr("15 MIN/DAY")
                                    color: "#FFFFFF"
                                    font.pixelSize: 10
                                    font.bold: true
                                }
                            }
                        }

                        Text {
                            text: qsTr("Rhodes et al. (2024) protocol: Neuroplastic scaffolding curriculum adapted for aphantasic cognition.")
                            color: Theme.textSecondary
                            font.pixelSize: Theme.fontSm
                            wrapMode: Text.WordWrap
                            width: parent.width
                        }

                        Row {
                            spacing: 16
                            Text {
                                text: qsTr("Completed: %1 / 42 Sessions").arg(storageManager.completedSessionsCount)
                                color: Theme.emeraldLight
                                font.pixelSize: Theme.fontSm
                                font.bold: true
                            }
                            Text {
                                text: "•"
                                color: Theme.textMuted
                            }
                            Text {
                                text: qsTr("Streak: %1 Days").arg(storageManager.trainingStreak)
                                color: Theme.amber
                                font.pixelSize: Theme.fontSm
                                font.bold: true
                            }
                        }
                    }

                    // Right action: Launch Current Session
                    Button {
                        id: launchTodayBtn
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Launch Today's Session\n(Week %1, Day %2) →").arg(storageManager.currentWeek).arg(storageManager.currentDay)
                        onClicked: {
                            root.launchSession(storageManager.currentWeek, storageManager.currentDay);
                        }
                        activeFocusOnTab: true
                        Keys.onReturnPressed: clicked()
                        Keys.onSpacePressed: clicked()
                        Accessible.role: Accessible.Button
                        Accessible.name: text

                        background: Rectangle {
                            color: launchTodayBtn.down ? Theme.primaryHover : (launchTodayBtn.hovered ? Theme.primaryLight : Theme.primary)
                            border.color: launchTodayBtn.activeFocus ? Theme.focusRing : Theme.primaryGlow
                            border.width: launchTodayBtn.activeFocus ? 2 : 1
                            radius: Theme.radiusMd
                            implicitHeight: 60
                            implicitWidth: 240
                        }
                        contentItem: Text {
                            text: launchTodayBtn.text
                            color: "#FFFFFF"
                            font.pixelSize: Theme.fontSm
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }

            // The 6 Weeks Grid
            Text {
                text: qsTr("Curriculum Schedule & Modules:")
                color: Theme.textPrimary
                font.pixelSize: Theme.fontMd
                font.bold: true
            }

            Column {
                width: parent.width
                spacing: 14

                Repeater {
                    model: root.allWeeks

                    Rectangle {
                        id: weekCard
                        width: parent.width
                        height: 125
                        radius: Theme.radiusMd
                        color: Theme.bgCard
                        border.color: (storageManager.currentWeek === modelData.week) ? modelData.themeColor : Theme.borderMedium
                        border.width: (storageManager.currentWeek === modelData.week) ? 2 : 1

                        Column {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 10

                            Row {
                                width: parent.width
                                spacing: 10

                                Rectangle {
                                    width: 10
                                    height: 10
                                    radius: 5
                                    color: modelData.themeColor
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    text: modelData.title
                                    color: Theme.textPrimary
                                    font.pixelSize: Theme.fontSm
                                    font.bold: true
                                }

                                Item { width: Math.max(10, parent.width - 550); height: 1 }

                                Text {
                                    text: modelData.scientificBasis
                                    color: Theme.textMuted
                                    font.pixelSize: Theme.fontXs
                                    font.italic: true
                                }
                            }

                            Text {
                                text: modelData.subtitle
                                color: Theme.textSecondary
                                font.pixelSize: Theme.fontXs
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                            // 7 Days Session Pills
                            Row {
                                spacing: 8

                                Repeater {
                                    model: [1, 2, 3, 4, 5, 6, 7]

                                    Rectangle {
                                        id: dayPill
                                        property int dayNum: modelData
                                        property bool isDone: storageManager.isSessionCompleted(modelData.week || (index < 7 ? (parent.parent.parent.modelData ? parent.parent.parent.modelData.week : 1) : 1), dayNum)
                                        property bool isCurrent: (storageManager.currentWeek === (parent.parent.parent.modelData ? parent.parent.parent.modelData.week : 1) && storageManager.currentDay === dayNum)

                                        width: 104
                                        height: 32
                                        radius: Theme.radiusSm
                                        color: isDone ? Theme.bgCardElevated : (isCurrent ? Theme.bgInput : Theme.bgDark)
                                        border.color: isDone ? Theme.emerald : (isCurrent ? Theme.primary : Theme.borderDim)
                                        border.width: (isDone || isCurrent) ? 1 : 1

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                var w = parent.parent.parent.parent.modelData.week;
                                                root.launchSession(w, dayPill.dayNum);
                                            }
                                        }

                                        Row {
                                            anchors.centerIn: parent
                                            spacing: 6

                                            Text {
                                                text: isDone ? "✓" : (isCurrent ? "▶" : "○")
                                                color: isDone ? Theme.emeraldLight : (isCurrent ? Theme.primaryLight : Theme.textMuted)
                                                font.pixelSize: 10
                                                font.bold: true
                                                anchors.verticalCenter: parent.verticalCenter
                                            }

                                            Text {
                                                text: qsTr("Day %1").arg(dayPill.dayNum)
                                                color: isDone ? Theme.textPrimary : Theme.textSecondary
                                                font.pixelSize: Theme.fontXs
                                                font.bold: isCurrent
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
