import QtQuick
import QtQuick.Controls
import "../components"

Item {
    id: root

    signal downloadDataRequested()

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: aboutCol.height + 60
        clip: true

        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        Column {
            id: aboutCol
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 48
            spacing: 20

            // Header Hero
            Rectangle {
                width: parent.width
                height: 120
                radius: Theme.radiusLg
                color: Theme.bgCardElevated
                border.color: Theme.borderBright
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 16

                    Rectangle {
                        width: 50
                        height: 50
                        radius: 25
                        color: Theme.primary
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            text: "🎓"
                            font.pixelSize: 26
                        }
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        Text {
                            text: qsTr("Scientific Basis & Research Ethics")
                            color: Theme.textPrimary
                            font.pixelSize: Theme.fontTitle - 4
                            font.bold: true
                        }

                        Text {
                            text: qsTr("Open-science platform combining validated psychometrics, neurocognitive training, and GPLv3 open source.")
                            color: Theme.textSecondary
                            font.pixelSize: Theme.fontSm
                        }
                    }
                }
            }

            // Section 1: Non-Medical Notice & Data Sovereignty
            Rectangle {
                width: parent.width
                height: ethicCol.height + 28
                radius: Theme.radiusMd
                color: Theme.bgCard
                border.color: Theme.borderMedium
                border.width: 1

                Column {
                    id: ethicCol
                    anchors.top: parent.top
                    anchors.topMargin: 14
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    width: parent.width - 40
                    spacing: 10

                    Text {
                        text: qsTr("Ethics & Research Declaration")
                        color: Theme.textPrimary
                        font.pixelSize: Theme.fontMd
                        font.bold: true
                    }

                    Text {
                        text: qsTr("• <b>Research Use Only:</b> This application is developed strictly for research, self-exploration, and educational study. It is <b>not a medical device</b> and does not diagnose, treat, or prevent clinical psychological conditions.<br><br>• <b>Data Sovereignty:</b> Operates 100% local-first. All scores, responses, and session notes stay in your private browser sandbox (IndexedDB / localStorage) and are never automatically transmitted to any server.<br><br>• <b>User Portability:</b> You may download your entire dataset anytime in standardized JSON or CSV format, or permanently erase it with one click.")
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontSm
                        wrapMode: Text.WordWrap
                        width: parent.width
                        lineHeight: 1.3
                    }
                }
            }

            // Section 2: Core Scientific Foundations & References
            Rectangle {
                width: parent.width
                height: bibCol.height + 28
                radius: Theme.radiusMd
                color: Theme.bgCard
                border.color: Theme.borderMedium
                border.width: 1

                Column {
                    id: bibCol
                    anchors.top: parent.top
                    anchors.topMargin: 14
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    width: parent.width - 40
                    spacing: 12

                    Text {
                        text: qsTr("Core Scientific Publications & Theoretical Foundations")
                        color: Theme.textPrimary
                        font.pixelSize: Theme.fontMd
                        font.bold: true
                    }

                    Repeater {
                        model: [
                            {
                                citation: "Marks, D. F. (1973). Visual Imagery Questionnaire (VVIQ).",
                                note: qsTr("The gold-standard 16-item self-report questionnaire for voluntary visual mental imagery vividness.")
                            },
                            {
                                citation: "Zeman, A., Dewar, M., & Della Sala, S. (2015). Lives without imagery – Congenital aphantasia. Cortex, 73, 378–380.",
                                note: qsTr("Formally established the term Aphantasia and standardized VVIQ classification.")
                            },
                            {
                                citation: "Dance, C. J., Ipser, A., & Simner, J. (2022). The prevalence of aphantasia in the general population. Consciousness and Cognition, 97, 103243.",
                                note: qsTr("Established standard population norms: scores < 32 indicate marked aphantasia (score 16 = total aphantasia); population mean = 56.8.")
                            },
                            {
                                citation: "Zeman, A., et al. (2020, 2024). Phantasia – Imagery vividness extremes & Trends in Cognitive Sciences.",
                                note: qsTr("Established hyperphantasia threshold (75-80 pts) and frontoparietal-occipitotemporal neuroplastic connectivity model.")
                            },
                            {
                                citation: "Dawes, A. J., Keogh, R., & Pearson, J. (2024). Multisensory subtypes of aphantasia. Neuroscience Research, 201, 50–59.",
                                note: qsTr("Demonstrated that aphantasia can be unimodal (visual only) or multisensory (multi-modal attenuation).")
                            },
                            {
                                citation: "Keogh, R., & Pearson, J. (2018, 2024). The blind mind & Revisiting the blind mind. Cortex & Neuroscience Research.",
                                note: qsTr("Psychophysical binocular rivalry priming proving aphantasia is a genuine sensory absence rather than metacognitive bias.")
                            },
                            {
                                citation: "Rhodes, J., Nedza, K., May, J., & Clements, L. (2024). Imagery training for athletes with low imagery abilities. J. Appl. Sport Psychol.",
                                note: qsTr("Foundational basis for 6-week curriculum: demonstrated that structured Functional Imagery Training significantly increases imagery capacity.")
                            },
                            {
                                citation: "Monzel, M. (2025). Aphantasie: Fakt oder Fiktion? Doctoral Dissertation, University of Bonn.",
                                note: qsTr("Exhaustive synthesis of cognitive compensation strategies: propositional networks, spatial models, and dual-coding.")
                            }
                        ]

                        Rectangle {
                            width: parent.width
                            height: citationCol.height + 16
                            radius: Theme.radiusSm
                            color: Theme.bgInput
                            border.color: Theme.borderDim
                            border.width: 1

                            Column {
                                id: citationCol
                                anchors.top: parent.top
                                anchors.topMargin: 8
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                width: parent.width - 24
                                spacing: 4

                                Text {
                                    text: modelData.citation
                                    color: Theme.primaryLight
                                    font.pixelSize: Theme.fontXs
                                    font.bold: true
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                }

                                Text {
                                    text: modelData.note
                                    color: Theme.textSecondary
                                    font.pixelSize: Theme.fontXs
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                }
                            }
                        }
                    }
                }
            }

            // Section 3: Qt Toolkit & GNU General Public License v3.0 (GPLv3)
            Rectangle {
                width: parent.width
                height: legalCol.height + 28
                radius: Theme.radiusMd
                color: Theme.bgCard
                border.color: Theme.borderMedium
                border.width: 1

                Column {
                    id: legalCol
                    anchors.top: parent.top
                    anchors.topMargin: 14
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    width: parent.width - 40
                    spacing: 12

                    Row {
                        width: parent.width
                        spacing: 10

                        Rectangle {
                            width: 32
                            height: 32
                            radius: 8
                            color: Theme.primaryGlow
                            anchors.verticalCenter: parent.verticalCenter
                            Text {
                                anchors.centerIn: parent
                                text: "📦"
                                font.pixelSize: 16
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 1
                            Text {
                                text: qsTr("Qt Framework & Open Source Licensing (GNU GPLv3)")
                                color: Theme.textPrimary
                                font.pixelSize: Theme.fontMd
                                font.bold: true
                            }
                            Text {
                                text: qsTr("WebAssembly Static Linking & Copyright Compliance")
                                color: Theme.textSecondary
                                font.pixelSize: Theme.fontXs
                            }
                        }

                        Rectangle {
                            width: 64
                            height: 22
                            radius: 11
                            color: Theme.bgInput
                            border.color: Theme.emeraldLight
                            border.width: 1
                            anchors.verticalCenter: parent.verticalCenter
                            Text {
                                anchors.centerIn: parent
                                text: "GPLv3"
                                color: Theme.emeraldLight
                                font.pixelSize: 10
                                font.bold: true
                            }
                        }
                    }

                    Text {
                        text: qsTr("• <b>GNU General Public License v3.0:</b> Phantasia is free, open-source software licensed under the GNU General Public License version 3 (GPLv3).<br><br>" +
                                   "• <b>Qt Framework & Static Linking:</b> This application is built with the Qt 6 framework (Qt Quick, Qt Quick Controls 2, Qt QML, Qt Gui, Qt Core). In the WebAssembly build running in the browser, all Qt libraries and C++ application modules are statically linked into a single WebAssembly binary (<code>appQtAphantasie.wasm</code>). Statically linking GPLv3 libraries combines them into a single executable work under GPLv3, which Phantasia adheres to in full.<br><br>" +
                                   "• <b>Source Code Availability (GPLv3 §6):</b> In accordance with GPLv3 Section 6, the complete machine-readable source code, CMake scripts, assets, and instructions to rebuild and relink the application are freely accessible at <b>https://github.com/mesw/phantasia</b>. Users have the full freedom to inspect, modify, and rebuild the application, or relink it with modified Qt versions.<br><br>" +
                                   "• <b>Trademark & Copyright:</b> Qt is a registered trademark of The Qt Company Ltd. and its subsidiaries. Qt is copyright © The Qt Company Ltd. and other contributors.<br><br>" +
                                   "• <b>Third-Party Assets:</b> Noto Color Emoji font is copyright © Google LLC and licensed under the SIL Open Font License 1.1. PeakFrequency breathing pacer is developed by mesw under MIT/Open Access.<br><br>" +
                                   "• <b>Disclaimer of Warranty (GPLv3 §§ 15 & 16):</b> This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for details.")
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontSm
                        wrapMode: Text.WordWrap
                        width: parent.width
                        lineHeight: 1.35
                    }

                    Row {
                        spacing: 12
                        topPadding: 4

                        Button {
                            id: viewLicenseBtn
                            text: qsTr("View Full GPLv3 License Text")
                            onClicked: licenseModal.open()
                            activeFocusOnTab: true
                            Keys.onReturnPressed: clicked()
                            Keys.onSpacePressed: clicked()
                            Accessible.role: Accessible.Button
                            Accessible.name: text

                            background: Rectangle {
                                color: viewLicenseBtn.down ? Theme.primaryHover : (viewLicenseBtn.hovered ? Theme.primaryLight : Theme.primary)
                                border.color: viewLicenseBtn.activeFocus ? Theme.focusRing : Theme.primaryGlow
                                border.width: viewLicenseBtn.activeFocus ? 2 : 1
                                radius: Theme.radiusSm
                                implicitHeight: 36
                                implicitWidth: 230
                            }
                            contentItem: Row {
                                anchors.centerIn: parent
                                spacing: 6
                                Text { text: "📜"; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter }
                                Text {
                                    text: viewLicenseBtn.text
                                    color: "#FFFFFF"
                                    font.pixelSize: Theme.fontXs
                                    font.bold: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }

                        Button {
                            id: qtTermsBtn
                            text: qsTr("Qt Licensing Terms ↗")
                            onClicked: storageManager.openUrl("https://www.qt.io/licensing/")
                            activeFocusOnTab: true
                            Keys.onReturnPressed: clicked()
                            Keys.onSpacePressed: clicked()
                            Accessible.role: Accessible.Button
                            Accessible.name: text

                            background: Rectangle {
                                color: qtTermsBtn.hovered ? Theme.bgCardElevated : Theme.bgInput
                                border.color: qtTermsBtn.activeFocus ? Theme.focusRing : Theme.borderBright
                                border.width: qtTermsBtn.activeFocus ? 2 : 1
                                radius: Theme.radiusSm
                                implicitHeight: 36
                                implicitWidth: 180
                            }
                            contentItem: Text {
                                text: qtTermsBtn.text
                                color: Theme.emeraldLight
                                font.pixelSize: Theme.fontXs
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Button {
                            id: gnuGplBtn
                            text: qsTr("GNU GPLv3 Official Text ↗")
                            onClicked: storageManager.openUrl("https://www.gnu.org/licenses/gpl-3.0.html")
                            activeFocusOnTab: true
                            Keys.onReturnPressed: clicked()
                            Keys.onSpacePressed: clicked()
                            Accessible.role: Accessible.Button
                            Accessible.name: text

                            background: Rectangle {
                                color: gnuGplBtn.hovered ? Theme.bgCardElevated : Theme.bgInput
                                border.color: gnuGplBtn.activeFocus ? Theme.focusRing : Theme.borderBright
                                border.width: gnuGplBtn.activeFocus ? 2 : 1
                                radius: Theme.radiusSm
                                implicitHeight: 36
                                implicitWidth: 200
                            }
                            contentItem: Text {
                                text: gnuGplBtn.text
                                color: Theme.primaryLight
                                font.pixelSize: Theme.fontXs
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
            }

            // Bottom Buttons
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16

                Button {
                    id: aboutDownloadBtn
                    text: qsTr("Download Participant Data (JSON / CSV)")
                    onClicked: root.downloadDataRequested()
                    activeFocusOnTab: true
                    Keys.onReturnPressed: clicked()
                    Keys.onSpacePressed: clicked()
                    Accessible.role: Accessible.Button
                    Accessible.name: text

                    background: Rectangle {
                        color: aboutDownloadBtn.down ? Theme.primaryHover : (aboutDownloadBtn.hovered ? Theme.primaryLight : Theme.primary)
                        border.color: aboutDownloadBtn.activeFocus ? Theme.focusRing : Theme.primaryGlow
                        border.width: aboutDownloadBtn.activeFocus ? 2 : 1
                        radius: Theme.radiusMd
                        implicitHeight: 44
                        implicitWidth: 320
                    }
                    contentItem: Row {
                        anchors.centerIn: parent
                        spacing: 8
                        Text {
                            text: "💾"
                            font.pixelSize: 14
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: aboutDownloadBtn.text
                            color: "#FFFFFF"
                            font.pixelSize: Theme.fontSm
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                Button {
                    id: aboutGithubBtn
                    text: qsTr("View Public Source Code on GitHub ↗")
                    onClicked: storageManager.openSourceCodeUrl()
                    activeFocusOnTab: true
                    Keys.onReturnPressed: clicked()
                    Keys.onSpacePressed: clicked()
                    Accessible.role: Accessible.Button
                    Accessible.name: text

                    background: Rectangle {
                        color: aboutGithubBtn.hovered ? Theme.bgCardElevated : Theme.bgInput
                        border.color: aboutGithubBtn.activeFocus ? Theme.focusRing : Theme.borderBright
                        border.width: aboutGithubBtn.activeFocus ? 2 : 1
                        radius: Theme.radiusMd
                        implicitHeight: 44
                        implicitWidth: 300
                    }
                    contentItem: Text {
                        text: aboutGithubBtn.text
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

    LicenseModal {
        id: licenseModal
    }
}
