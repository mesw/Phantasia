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
                            text: qsTr("Open-science platform combining validated psychometrics and neurocognitive imagery training.")
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
                                note: qsTr("Formally established the medical condition name Aphantasia and standardized VVIQ diagnostic classification.")
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

            // Bottom Buttons
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16

                Button {
                    text: qsTr("Download Participant Data (JSON / CSV)")
                    onClicked: root.downloadDataRequested()
                    background: Rectangle {
                        color: Theme.primary
                        radius: Theme.radiusMd
                        implicitHeight: 44
                        implicitWidth: 300
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

                Button {
                    text: qsTr("View Public Source Code on GitHub ↗")
                    onClicked: storageManager.openSourceCodeUrl()
                    background: Rectangle {
                        color: Theme.bgCardElevated
                        border.color: Theme.borderBright
                        radius: Theme.radiusMd
                        implicitHeight: 44
                        implicitWidth: 280
                    }
                    contentItem: Text {
                        text: parent.text
                        color: Theme.textPrimary
                        font.pixelSize: Theme.fontSm
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
}
