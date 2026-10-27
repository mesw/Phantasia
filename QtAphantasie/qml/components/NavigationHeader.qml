import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    property int currentTab: 0 // 0: Assessment, 1: Training, 2: Progress, 3: Ethics/About
    signal tabChanged(int tabIndex)
    signal downloadDataRequested()

    implicitWidth: 1024
    implicitHeight: 70
    color: Theme.bgDark
    border.color: Theme.borderDim
    border.width: 1

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: Theme.borderMedium
    }

    Row {
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        spacing: 14

        // Logo Icon
        Rectangle {
            width: 40
            height: 40
            radius: 12
            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.primary }
                GradientStop { position: 1.0; color: Theme.accent }
            }
            anchors.verticalCenter: parent.verticalCenter

            Text {
                anchors.centerIn: parent
                text: "👁"
                font.pixelSize: 20
            }
        }

        // App Title
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Row {
                spacing: 8
                Text {
                    text: qsTr("Aphantasia")
                    color: Theme.textPrimary
                    font.pixelSize: Theme.fontLg
                    font.bold: true
                }
                Rectangle {
                    width: 58
                    height: 18
                    radius: 9
                    color: Theme.bgCardElevated
                    border.color: Theme.primary
                    border.width: 1
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("RESEARCH")
                        color: Theme.primaryLight
                        font.pixelSize: 9
                        font.bold: true
                    }
                }
            }

            Text {
                text: qsTr("Diagnostic Assessment & Neurocognitive Training")
                color: Theme.textMuted
                font.pixelSize: Theme.fontXs
            }
        }
    }

    // Centered Navigation Tabs
    Row {
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: [
                { id: 0, label: qsTr("Diagnostic"), icon: "📋" },
                { id: 1, label: qsTr("6-Week Training"), icon: "🧠" },
                { id: 2, label: qsTr("Progress"), icon: "📈" },
                { id: 3, label: qsTr("Ethics & Sources"), icon: "📚" }
            ]

            Rectangle {
                id: tabBtn
                width: 130
                height: 38
                radius: Theme.radiusMd
                color: (root.currentTab === modelData.id) ? Theme.bgCardElevated : "transparent"
                border.color: (root.currentTab === modelData.id) ? Theme.primary : "transparent"
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.currentTab = modelData.id;
                        root.tabChanged(modelData.id);
                    }
                    onEntered: {
                        if (root.currentTab !== modelData.id) {
                            tabBtn.color = Theme.bgInput;
                        }
                    }
                    onExited: {
                        if (root.currentTab !== modelData.id) {
                            tabBtn.color = "transparent";
                        }
                    }
                }

                Row {
                    anchors.centerIn: parent
                    spacing: 6
                    Text {
                        text: modelData.icon
                        font.pixelSize: 13
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: modelData.label
                        color: (root.currentTab === modelData.id) ? Theme.textPrimary : Theme.textSecondary
                        font.pixelSize: Theme.fontSm
                        font.bold: (root.currentTab === modelData.id)
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }

    // Right-Hand Action Buttons
    Row {
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        // Download My Data Button
        Button {
            text: qsTr("Download My Data")
            onClicked: root.downloadDataRequested()
            background: Rectangle {
                color: Theme.bgCardElevated
                border.color: Theme.borderBright
                radius: Theme.radiusMd
                implicitHeight: 34
                implicitWidth: 140
            }
            contentItem: Row {
                anchors.centerIn: parent
                spacing: 6
                Text {
                    text: "💾"
                    font.pixelSize: 12
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: parent.parent.text
                    color: Theme.textPrimary
                    font.pixelSize: Theme.fontXs
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // View Source Button (GitHub)
        Button {
            text: qsTr("Source Code")
            onClicked: storageManager.openSourceCodeUrl()
            background: Rectangle {
                color: "transparent"
                border.color: Theme.borderMedium
                radius: Theme.radiusMd
                implicitHeight: 34
                implicitWidth: 100
            }
            contentItem: Row {
                anchors.centerIn: parent
                spacing: 5
                Text {
                    text: "⚡"
                    font.pixelSize: 12
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: parent.parent.text
                    color: Theme.textSecondary
                    font.pixelSize: Theme.fontXs
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // Bilingual Toggle Pill (DE / EN)
        Rectangle {
            width: 84
            height: 34
            radius: Theme.radiusPill
            color: Theme.bgInput
            border.color: Theme.borderMedium
            border.width: 1

            Row {
                anchors.fill: parent

                // DE
                Rectangle {
                    width: parent.width / 2
                    height: parent.height
                    radius: Theme.radiusPill
                    color: (languageManager.currentLanguage === "de") ? Theme.primary : "transparent"

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: languageManager.setLanguage("de")
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "DE"
                        color: (languageManager.currentLanguage === "de") ? "#FFFFFF" : Theme.textMuted
                        font.pixelSize: Theme.fontXs
                        font.bold: (languageManager.currentLanguage === "de")
                    }
                }

                // EN
                Rectangle {
                    width: parent.width / 2
                    height: parent.height
                    radius: Theme.radiusPill
                    color: (languageManager.currentLanguage === "en") ? Theme.primary : "transparent"

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: languageManager.setLanguage("en")
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "EN"
                        color: (languageManager.currentLanguage === "en") ? "#FFFFFF" : Theme.textMuted
                        font.pixelSize: Theme.fontXs
                        font.bold: (languageManager.currentLanguage === "en")
                    }
                }
            }
        }
    }
}
