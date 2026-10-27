import QtQuick
import QtQuick.Controls

Dialog {
    id: root

    modal: true
    closePolicy: Popup.NoAutoClose
    dim: true

    anchors.centerIn: Overlay.overlay
    width: Math.min(680, Overlay.overlay ? Overlay.overlay.width - 40 : 640)
    padding: 0

    background: Rectangle {
        color: Theme.bgCard
        radius: Theme.radiusLg
        border.color: Theme.borderBright
        border.width: 1
    }

    contentItem: Column {
        spacing: 0
        width: parent.width

        // Header
        Rectangle {
            width: parent.width
            height: 70
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
                anchors.leftMargin: 24
                anchors.verticalCenter: parent.verticalCenter
                spacing: 14

                Rectangle {
                    width: 38
                    height: 38
                    radius: 19
                    color: Theme.primary
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "⚖"
                        font.pixelSize: 20
                        color: "#FFFFFF"
                    }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    Text {
                        text: qsTr("Informed Consent & Study Information")
                        color: Theme.textPrimary
                        font.pixelSize: Theme.fontLg
                        font.bold: true
                    }

                    Text {
                        text: qsTr("Research Ethics, Data Sovereignty & Non-Medical Device Notice")
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontXs
                    }
                }
            }
        }

        // Scrollable Body
        Flickable {
            width: parent.width
            height: Math.min(380, Overlay.overlay ? Overlay.overlay.height - 240 : 380)
            contentWidth: width
            contentHeight: bodyCol.height + 40
            clip: true

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            Column {
                id: bodyCol
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 48
                spacing: 16

                // Section 1: Non-Medical Notice
                Rectangle {
                    width: parent.width
                    height: noticeCol.height + 24
                    color: "#2D1515" // Deep warning red
                    radius: Theme.radiusMd
                    border.color: "#7F1D1D"
                    border.width: 1

                    Column {
                        id: noticeCol
                        anchors.top: parent.top
                        anchors.topMargin: 12
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        width: parent.width - 32
                        spacing: 6

                        Row {
                            spacing: 8
                            Text {
                                text: "⚠️"
                                font.pixelSize: Theme.fontMd
                            }
                            Text {
                                text: qsTr("Research & Educational Instrument — Not a Medical Device")
                                color: "#FCA5A5"
                                font.pixelSize: Theme.fontSm
                                font.bold: true
                            }
                        }

                        Text {
                            text: qsTr("This application is developed strictly for empirical research, cognitive self-exploration, and educational purposes. It is NOT a medical device, does not provide medical or psychiatric diagnoses, and is not a substitute for clinical psychological therapy or medical care.")
                            color: "#FECACA"
                            font.pixelSize: Theme.fontXs
                            wrapMode: Text.WordWrap
                            width: parent.width
                            lineHeight: 1.3
                        }
                    }
                }

                // Section 2: Data Sovereignty
                Rectangle {
                    width: parent.width
                    height: dataCol.height + 24
                    color: Theme.bgInput
                    radius: Theme.radiusMd
                    border.color: Theme.borderDim
                    border.width: 1

                    Column {
                        id: dataCol
                        anchors.top: parent.top
                        anchors.topMargin: 12
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        width: parent.width - 32
                        spacing: 6

                        Row {
                            spacing: 8
                            Text {
                                text: "🔒"
                                font.pixelSize: Theme.fontMd
                            }
                            Text {
                                text: qsTr("Data Sovereignty: Your Data Stays Exclusively on Your Device")
                                color: Theme.emeraldLight
                                font.pixelSize: Theme.fontSm
                                font.bold: true
                            }
                        }

                        Text {
                            text: qsTr("The application operates strictly local-first. None of your assessment answers, scores, training logs, or IP addresses are transmitted to external servers, cloud databases, or third-party trackers. All state is held in your browser's private local sandbox. You can download your data at any time via 'Download My Data' (JSON or CSV) or permanently delete it with one click.")
                            color: Theme.textSecondary
                            font.pixelSize: Theme.fontXs
                            wrapMode: Text.WordWrap
                            width: parent.width
                            lineHeight: 1.3
                        }
                    }
                }

                // Section 3: Open Science & Scientific Basis
                Text {
                    text: qsTr("Scientific Basis & Transparency:")
                    color: Theme.textPrimary
                    font.pixelSize: Theme.fontSm
                    font.bold: true
                }

                Text {
                    text: qsTr("The diagnostics adapt the gold-standard Visual Imagery Questionnaire (VVIQ; Marks 1973) and multisensory profiling (Dawes et al. 2024). The 6-week curriculum operationalizes Functional Imagery Training (FIT) derived from neuroscientific intervention protocols (Rhodes et al. 2024; Monzel 2025; Zeman 2024). Full algorithms and scoring rubrics are openly auditable via the public GitHub repository.")
                    color: Theme.textMuted
                    font.pixelSize: Theme.fontXs
                    wrapMode: Text.WordWrap
                    width: parent.width
                    lineHeight: 1.3
                }
            }
        }

        // Footer Actions
        Rectangle {
            width: parent.width
            height: 72
            color: Theme.bgCardElevated
            radius: Theme.radiusLg
            Rectangle {
                anchors.top: parent.top
                width: parent.width
                height: 1
                color: Theme.borderMedium
            }

            Row {
                anchors.right: parent.right
                anchors.rightMargin: 24
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                Button {
                    id: githubBtn
                    text: qsTr("View Source Code (GitHub)")
                    onClicked: storageManager.openSourceCodeUrl()
                    activeFocusOnTab: true
                    Keys.onReturnPressed: clicked()
                    Keys.onSpacePressed: clicked()
                    Accessible.role: Accessible.Button
                    Accessible.name: text

                    background: Rectangle {
                        color: githubBtn.hovered ? Theme.bgCardElevated : Theme.bgInput
                        border.color: githubBtn.activeFocus ? Theme.focusRing : Theme.borderBright
                        border.width: githubBtn.activeFocus ? 2 : 1
                        radius: Theme.radiusMd
                        implicitHeight: 44
                        implicitWidth: 190
                    }
                    contentItem: Text {
                        text: githubBtn.text
                        color: Theme.textPrimary
                        font.pixelSize: Theme.fontSm
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Button {
                    id: consentBtn
                    text: qsTr("I Understand & Consent to Participate")
                    focus: true
                    activeFocusOnTab: true
                    Keys.onReturnPressed: clicked()
                    Keys.onSpacePressed: clicked()
                    Accessible.role: Accessible.Button
                    Accessible.name: text

                    onClicked: {
                        storageManager.saveConsent(true);
                        root.accept();
                    }
                    background: Rectangle {
                        color: consentBtn.down ? Theme.primaryHover : (consentBtn.hovered ? Theme.primaryLight : Theme.primary)
                        border.color: consentBtn.activeFocus ? Theme.focusRing : Theme.primaryGlow
                        border.width: consentBtn.activeFocus ? 2 : 1
                        radius: Theme.radiusMd
                        implicitHeight: 44
                        implicitWidth: 280
                    }
                    contentItem: Text {
                        text: consentBtn.text
                        color: "#FFFFFF"
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
