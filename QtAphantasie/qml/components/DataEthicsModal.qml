import QtQuick
import QtQuick.Controls

Dialog {
    id: root

    modal: true
    dim: true
    anchors.centerIn: Overlay.overlay
    width: Math.min(620, Overlay.overlay ? Overlay.overlay.width - 40 : 600)
    padding: 0

    property bool showConfirmClear: false

    background: Rectangle {
        color: Theme.bgCard
        radius: Theme.radiusLg
        border.color: Theme.borderBright
        border.width: 1
    }

    contentItem: Column {
        width: parent.width
        spacing: 0

        // Header
        Rectangle {
            width: parent.width
            height: 64
            color: Theme.bgCardElevated
            radius: Theme.radiusLg

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: Theme.borderMedium
            }

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                Text {
                    text: "🔒"
                    font.pixelSize: 20
                }

                Text {
                    text: qsTr("Data Sovereignty & Export Center")
                    color: Theme.textPrimary
                    font.pixelSize: Theme.fontMd
                    font.bold: true
                }
            }

            // Close button
            Button {
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                text: "✕"
                onClicked: root.close()
                background: Rectangle {
                    color: "transparent"
                    implicitWidth: 32
                    implicitHeight: 32
                }
                contentItem: Text {
                    text: parent.text
                    color: Theme.textMuted
                    font.pixelSize: Theme.fontMd
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        // Body
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 40
            spacing: 16
            topPadding: 20
            bottomPadding: 20

            Text {
                text: qsTr("Your data belongs exclusively to you. All assessments, VVIQ scores, and daily training logs are stored strictly inside your browser's private local sandbox. No data is ever transmitted to remote servers.")
                color: Theme.textSecondary
                font.pixelSize: Theme.fontSm
                wrapMode: Text.WordWrap
                width: parent.width
                lineHeight: 1.3
            }

            // Export Options
            Rectangle {
                width: parent.width
                height: 110
                radius: Theme.radiusMd
                color: Theme.bgInput
                border.color: Theme.borderMedium
                border.width: 1

                Column {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 10

                    Text {
                        text: qsTr("Export Participant Records:")
                        color: Theme.textPrimary
                        font.pixelSize: Theme.fontSm
                        font.bold: true
                    }

                    Row {
                        spacing: 12

                        Button {
                            text: qsTr("Download JSON (.json)")
                            onClicked: {
                                storageManager.downloadDataAsJson();
                            }
                            background: Rectangle {
                                color: Theme.primary
                                radius: Theme.radiusSm
                                implicitHeight: 38
                                implicitWidth: 180
                            }
                            contentItem: Text {
                                text: parent.text
                                color: "#FFFFFF"
                                font.pixelSize: Theme.fontXs
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Button {
                            text: qsTr("Download CSV (.csv)")
                            onClicked: {
                                storageManager.downloadDataAsCsv();
                            }
                            background: Rectangle {
                                color: Theme.bgCardElevated
                                border.color: Theme.borderBright
                                radius: Theme.radiusSm
                                implicitHeight: 38
                                implicitWidth: 180
                            }
                            contentItem: Text {
                                text: parent.text
                                color: Theme.textPrimary
                                font.pixelSize: Theme.fontXs
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
            }

            // Erasure Section
            Rectangle {
                width: parent.width
                height: root.showConfirmClear ? 130 : 70
                radius: Theme.radiusMd
                color: "#1F1212"
                border.color: "#7F1D1D"
                border.width: 1

                Column {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 8

                    Row {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: "⚠️"
                            font.pixelSize: 14
                        }

                        Text {
                            text: qsTr("Erase All Local Participant Data")
                            color: "#FCA5A5"
                            font.pixelSize: Theme.fontSm
                            font.bold: true
                        }

                        Item { width: Math.max(10, parent.width - 340); height: 1 }

                        Button {
                            visible: !root.showConfirmClear
                            text: qsTr("Clear All Data")
                            onClicked: root.showConfirmClear = true
                            background: Rectangle {
                                color: "#7F1D1D"
                                radius: Theme.radiusSm
                                implicitHeight: 28
                                implicitWidth: 120
                            }
                            contentItem: Text {
                                text: parent.text
                                color: "#FFFFFF"
                                font.pixelSize: Theme.fontXs
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }

                    // Confirmation banner
                    Column {
                        visible: root.showConfirmClear
                        spacing: 8
                        width: parent.width

                        Text {
                            text: qsTr("Are you sure? This will irreversibly delete all your test scores and training logs from this browser.")
                            color: "#FECACA"
                            font.pixelSize: Theme.fontXs
                            wrapMode: Text.WordWrap
                            width: parent.width
                        }

                        Row {
                            spacing: 10

                            Button {
                                text: qsTr("Yes, Permanently Delete All Data")
                                onClicked: {
                                    storageManager.clearAllData();
                                    root.showConfirmClear = false;
                                    root.close();
                                }
                                background: Rectangle {
                                    color: Theme.rose
                                    radius: Theme.radiusSm
                                    implicitHeight: 30
                                    implicitWidth: 230
                                }
                                contentItem: Text {
                                    text: parent.text
                                    color: "#FFFFFF"
                                    font.pixelSize: Theme.fontXs
                                    font.bold: true
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            Button {
                                text: qsTr("Cancel")
                                onClicked: root.showConfirmClear = false
                                background: Rectangle {
                                    color: Theme.bgCardElevated
                                    radius: Theme.radiusSm
                                    implicitHeight: 30
                                    implicitWidth: 80
                                }
                                contentItem: Text {
                                    text: parent.text
                                    color: Theme.textSecondary
                                    font.pixelSize: Theme.fontXs
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
