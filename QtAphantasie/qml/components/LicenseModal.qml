import QtQuick
import QtQuick.Controls

Dialog {
    id: root

    modal: true
    dim: true
    anchors.centerIn: Overlay.overlay
    width: Math.min(740, Overlay.overlay ? Overlay.overlay.width - 40 : 720)
    height: Math.min(680, Overlay.overlay ? Overlay.overlay.height - 40 : 660)
    padding: 0

    background: Rectangle {
        color: Theme.bgCard
        radius: Theme.radiusLg
        border.color: Theme.borderBright
        border.width: 1
    }

    contentItem: Column {
        anchors.fill: parent
        spacing: 0

        // ── Header ───────────────────────────────────────────────────────────
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

                Rectangle {
                    width: 38
                    height: 38
                    radius: Theme.radiusMd
                    color: Theme.primaryGlow
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "📜"
                        font.pixelSize: 20
                    }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    Text {
                        text: qsTr("GNU General Public License v3.0 (GPLv3)")
                        color: Theme.textPrimary
                        font.pixelSize: Theme.fontMd
                        font.bold: true
                    }

                    Text {
                        text: qsTr("Qt Toolkit & WebAssembly Static Linking Compliance")
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontXs
                    }
                }
            }

            // Close button
            Button {
                id: modalCloseBtn
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                text: "✕"
                onClicked: root.close()
                activeFocusOnTab: true
                Keys.onReturnPressed: clicked()
                Keys.onSpacePressed: clicked()
                Accessible.role: Accessible.Button
                Accessible.name: qsTr("Close License Dialog")

                background: Rectangle {
                    color: modalCloseBtn.hovered ? Theme.bgCard : "transparent"
                    border.color: modalCloseBtn.activeFocus ? Theme.focusRing : "transparent"
                    border.width: modalCloseBtn.activeFocus ? 2 : 0
                    radius: 16
                    implicitWidth: 32
                    implicitHeight: 32
                }
                contentItem: Text {
                    text: modalCloseBtn.text
                    color: modalCloseBtn.hovered ? Theme.textPrimary : Theme.textMuted
                    font.pixelSize: Theme.fontMd
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        // ── Summary Box ──────────────────────────────────────────────────────
        Rectangle {
            width: parent.width - 32
            anchors.horizontalCenter: parent.horizontalCenter
            height: summaryCol.height + 20
            color: Theme.bgInput
            radius: Theme.radiusMd
            border.color: Theme.borderDim
            border.width: 1

            Column {
                id: summaryCol
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 14
                anchors.right: parent.right
                anchors.rightMargin: 14
                spacing: 6

                Text {
                    text: qsTr("Open Source Static Linking Disclosure & Legal Compliance:")
                    color: Theme.primaryLight
                    font.pixelSize: Theme.fontXs
                    font.bold: true
                }

                Text {
                    text: qsTr("• <b>Qt Framework:</b> This application is built with the Qt 6 Toolkit (The Qt Company Ltd.) under the GNU General Public License v3.0.<br>" +
                               "• <b>Static Linking:</b> In WebAssembly, Qt libraries and C++ application code are compiled into a unified binary (<code>appQtAphantasie.wasm</code>). As a statically linked work under GPLv3, Phantasia is released in its entirety under GPLv3.<br>" +
                               "• <b>Source Availability (GPLv3 §6):</b> Full source code, build scripts, and relinking recipes are freely available at <b>https://github.com/mesw/phantasia</b>.<br>" +
                               "• <b>Trademarks:</b> Qt is a registered trademark of The Qt Company Ltd. and its subsidiaries.")
                    color: Theme.textSecondary
                    font.pixelSize: 11
                    wrapMode: Text.WordWrap
                    width: parent.width
                    lineHeight: 1.3
                }
            }
        }

        Item { width: parent.width; height: 10 }

        // ── Quick Links Row ──────────────────────────────────────────────────
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Button {
                id: gnuLinkBtn
                text: qsTr("GNU GPLv3 (gnu.org) ↗")
                onClicked: storageManager.openUrl("https://www.gnu.org/licenses/gpl-3.0.html")
                activeFocusOnTab: true
                Keys.onReturnPressed: clicked()
                Keys.onSpacePressed: clicked()
                Accessible.role: Accessible.Button
                Accessible.name: text

                background: Rectangle {
                    color: gnuLinkBtn.hovered ? Theme.bgCardElevated : Theme.bgInput
                    border.color: gnuLinkBtn.activeFocus ? Theme.focusRing : Theme.borderBright
                    border.width: gnuLinkBtn.activeFocus ? 2 : 1
                    radius: Theme.radiusSm
                    implicitHeight: 32
                    implicitWidth: 190
                }
                contentItem: Text {
                    text: gnuLinkBtn.text
                    color: Theme.primaryLight
                    font.pixelSize: Theme.fontXs
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Button {
                id: qtLinkBtn
                text: qsTr("Qt Licensing Terms ↗")
                onClicked: storageManager.openUrl("https://www.qt.io/licensing/")
                activeFocusOnTab: true
                Keys.onReturnPressed: clicked()
                Keys.onSpacePressed: clicked()
                Accessible.role: Accessible.Button
                Accessible.name: text

                background: Rectangle {
                    color: qtLinkBtn.hovered ? Theme.bgCardElevated : Theme.bgInput
                    border.color: qtLinkBtn.activeFocus ? Theme.focusRing : Theme.borderBright
                    border.width: qtLinkBtn.activeFocus ? 2 : 1
                    radius: Theme.radiusSm
                    implicitHeight: 32
                    implicitWidth: 180
                }
                contentItem: Text {
                    text: qtLinkBtn.text
                    color: Theme.emeraldLight
                    font.pixelSize: Theme.fontXs
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Button {
                id: repoLinkBtn
                text: qsTr("GitHub Repository ↗")
                onClicked: storageManager.openSourceCodeUrl()
                activeFocusOnTab: true
                Keys.onReturnPressed: clicked()
                Keys.onSpacePressed: clicked()
                Accessible.role: Accessible.Button
                Accessible.name: text

                background: Rectangle {
                    color: repoLinkBtn.hovered ? Theme.bgCardElevated : Theme.bgInput
                    border.color: repoLinkBtn.activeFocus ? Theme.focusRing : Theme.borderBright
                    border.width: repoLinkBtn.activeFocus ? 2 : 1
                    radius: Theme.radiusSm
                    implicitHeight: 32
                    implicitWidth: 180
                }
                contentItem: Text {
                    text: repoLinkBtn.text
                    color: Theme.textPrimary
                    font.pixelSize: Theme.fontXs
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Item { width: parent.width; height: 10 }

        // ── Full License Text Scroll Area ─────────────────────────────────────
        Rectangle {
            width: parent.width - 32
            anchors.horizontalCenter: parent.horizontalCenter
            height: Math.max(160, root.height - 64 - summaryCol.height - 20 - 32 - 20 - 56 - 24)
            color: Theme.bgDark
            radius: Theme.radiusMd
            border.color: Theme.borderDim
            border.width: 1
            clip: true

            Flickable {
                id: licenseFlick
                anchors.fill: parent
                anchors.margins: 12
                contentWidth: licenseTextItem.width
                contentHeight: licenseTextItem.height
                clip: true

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

                TextEdit {
                    id: licenseTextItem
                    width: licenseFlick.width - 16
                    text: storageManager.getGpl3LicenseText()
                    readOnly: true
                    selectByMouse: true
                    wrapMode: TextEdit.Wrap
                    font.family: "Consolas, Courier New, monospace"
                    font.pixelSize: 11
                    color: Theme.textSecondary
                    activeFocusOnTab: true
                }
            }
        }

        // ── Footer ───────────────────────────────────────────────────────────
        Item {
            width: parent.width
            height: 56

            Button {
                id: closeFooterBtn
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Close")
                onClicked: root.close()
                activeFocusOnTab: true
                focus: true
                Keys.onReturnPressed: clicked()
                Keys.onSpacePressed: clicked()
                Accessible.role: Accessible.Button
                Accessible.name: text

                background: Rectangle {
                    color: closeFooterBtn.down ? Theme.primaryHover : (closeFooterBtn.hovered ? Theme.primaryLight : Theme.primary)
                    border.color: closeFooterBtn.activeFocus ? Theme.focusRing : Theme.primaryGlow
                    border.width: closeFooterBtn.activeFocus ? 2 : 1
                    radius: Theme.radiusMd
                    implicitHeight: 38
                    implicitWidth: 120
                }
                contentItem: Text {
                    text: closeFooterBtn.text
                    color: "#FFFFFF"
                    font.pixelSize: Theme.fontSm
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    Keys.onEscapePressed: root.close()
}
