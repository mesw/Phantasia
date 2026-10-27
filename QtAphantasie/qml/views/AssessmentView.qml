import QtQuick
import QtQuick.Controls
import "../components"

Item {
    id: root

    property int assessmentStep: 1 // 1: Apple Test, 2: VVIQ, 3: Multisensory, 4: Report

    property int chosenAppleLevel: 5
    property int currentVviqScore: 16
    property var currentItemAnswers: []
    property var currentPsiqScores: ({})

    signal navigateToTraining()
    signal downloadDataRequested()

    focus: true
    Keys.onDigit1Pressed: if (root.assessmentStep === 1) root.chosenAppleLevel = 1
    Keys.onDigit2Pressed: if (root.assessmentStep === 1) root.chosenAppleLevel = 2
    Keys.onDigit3Pressed: if (root.assessmentStep === 1) root.chosenAppleLevel = 3
    Keys.onDigit4Pressed: if (root.assessmentStep === 1) root.chosenAppleLevel = 4
    Keys.onDigit5Pressed: if (root.assessmentStep === 1) root.chosenAppleLevel = 5
    Keys.onReturnPressed: {
        if (root.assessmentStep === 1) {
            root.assessmentStep = 2;
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 12

        // ==========================================
        // STEPPER HEADER
        // ==========================================
        Rectangle {
            id: stepperHeader
            width: parent.width
            height: 78
            color: Theme.bgCard
            radius: Theme.radiusMd
            border.color: Theme.borderMedium
            border.width: 1

            Row {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 16

                Column {
                    width: parent.width - 340
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 3

                    Text {
                        text: {
                            switch (root.assessmentStep) {
                            case 1: return qsTr("Step 1 of 3: Intuitive Onboarding (\"The Apple Test\")");
                            case 2: return qsTr("Step 2 of 3: Standardized VVIQ Evaluation (Marks 1973)");
                            case 3: return qsTr("Step 3 of 3: Multi-Sensory Modality Check (Dawes et al. 2024)");
                            case 4: return qsTr("Diagnostic Assessment Report & Baseline Profile");
                            default: return "";
                            }
                        }
                        color: Theme.textPrimary
                        font.pixelSize: Theme.fontLg
                        font.bold: true
                    }

                    Text {
                        text: {
                            switch (root.assessmentStep) {
                            case 1: return qsTr("Close your eyes, imagine a red apple on a table, and select the illustration closest to your subjective experience.");
                            case 2: return qsTr("16 standardized psychometric items across 4 vivid real-world visualization scenarios.");
                            case 3: return qsTr("Evaluating non-visual sensory modalities (hearing, touch, movement, smell, taste, emotion).");
                            case 4: return qsTr("Your validated cognitive vividness classification, percentile rank, and training recommendations.");
                            default: return "";
                            }
                        }
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontXs
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }
                }

                // Visual Step Badges
                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    Repeater {
                        model: [
                            { step: 1, label: qsTr("Apple") },
                            { step: 2, label: qsTr("VVIQ") },
                            { step: 3, label: qsTr("Multisensory") },
                            { step: 4, label: qsTr("Report") }
                        ]

                        Rectangle {
                            required property var modelData
                            readonly property bool isCurrent: root.assessmentStep === modelData.step
                            readonly property bool isDone: root.assessmentStep > modelData.step

                            width: 72
                            height: 36
                            radius: Theme.radiusSm
                            color: isCurrent ? Theme.primary : (isDone ? Theme.bgCardElevated : Theme.bgInput)
                            border.color: isCurrent ? Theme.primaryLight : (isDone ? Theme.emerald : Theme.borderDim)
                            border.width: isCurrent || isDone ? 2 : 1

                            Row {
                                anchors.centerIn: parent
                                spacing: 4
                                Text {
                                    text: isDone ? "✓" : modelData.step.toString()
                                    color: isDone ? Theme.emeraldLight : (isCurrent ? "#FFFFFF" : Theme.textMuted)
                                    font.bold: true
                                    font.pixelSize: Theme.fontXs
                                }
                                Text {
                                    text: modelData.label
                                    color: isCurrent ? "#FFFFFF" : (isDone ? Theme.textPrimary : Theme.textMuted)
                                    font.bold: isCurrent
                                    font.pixelSize: 10
                                }
                            }
                        }
                    }
                }
            }
        }

        // ==========================================
        // MAIN STEP CONTAINER
        // ==========================================
        Item {
            id: mainContentItem
            width: parent.width
            height: parent.height - stepperHeader.height - (root.assessmentStep < 4 ? wizardFooter.height : 0) - 24

            // STEP 1: THE APPLE TEST
            Item {
                anchors.fill: parent
                visible: root.assessmentStep === 1

                Flickable {
                    anchors.fill: parent
                    contentWidth: width
                    contentHeight: appleCol.height + 20
                    clip: true

                    ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                    Column {
                        id: appleCol
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width
                        spacing: 16

                        // 5 Apple Level Cards
                        Flow {
                            width: parent.width
                            spacing: 16

                            Repeater {
                                model: vviqEngine.getAppleLevels()

                                AppleTestCard {
                                    level: modelData.level
                                    title: modelData.title
                                    description: modelData.description
                                    quote: modelData.quote
                                    isSelected: (root.chosenAppleLevel === modelData.level)
                                    onClicked: {
                                        root.chosenAppleLevel = modelData.level;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // STEP 2: STANDARDIZED VVIQ EVALUATION
            Item {
                anchors.fill: parent
                visible: root.assessmentStep === 2

                VviqQuestionnaire {
                    anchors.centerIn: parent
                    onCompleted: function(answersList, totalScore) {
                        root.currentItemAnswers = answersList;
                        root.currentVviqScore = totalScore;
                        root.assessmentStep = 3;
                    }
                }
            }

            // STEP 3: MULTI-SENSORY PROFILING
            Item {
                anchors.fill: parent
                visible: root.assessmentStep === 3

                MultisensoryCheck {
                    anchors.centerIn: parent
                    onCompleted: function(psiqScores) {
                        root.currentPsiqScores = psiqScores;

                        var cat = vviqEngine.classifyVviq(root.currentVviqScore);
                        var pct = vviqEngine.calculatePercentile(root.currentVviqScore);

                        // Save assessment result locally
                        storageManager.saveAssessmentResult(
                            root.chosenAppleLevel,
                            root.currentVviqScore,
                            cat,
                            pct,
                            root.currentPsiqScores,
                            root.currentItemAnswers
                        );

                        root.assessmentStep = 4;
                    }
                }
            }

            // STEP 4: DIAGNOSTIC REPORT
            Item {
                anchors.fill: parent
                visible: root.assessmentStep === 4

                DiagnosticReport {
                    anchors.fill: parent
                    appleLevel: root.chosenAppleLevel
                    vviqScore: root.currentVviqScore
                    psiqScores: root.currentPsiqScores
                    itemAnswers: root.currentItemAnswers

                    onStartTrainingClicked: root.navigateToTraining()
                    onDownloadReportClicked: root.downloadDataRequested()
                    onRetakeClicked: {
                        root.assessmentStep = 1;
                    }
                }
            }
        }

        // ==========================================
        // PERSISTENT WIZARD FOOTER (ALWAYS VISIBLE)
        // ==========================================
        Rectangle {
            id: wizardFooter
            width: parent.width
            height: 62
            color: Theme.bgCardElevated
            radius: Theme.radiusMd
            border.color: Theme.borderBright
            border.width: 1
            visible: root.assessmentStep < 4

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                // Back Button (for Step 2 and Step 3)
                Button {
                    id: wizardBackBtn
                    visible: root.assessmentStep > 1
                    text: root.assessmentStep === 2 ? qsTr("← Back to Step 1 (Apple Test)") : qsTr("← Back to Step 2 (VVIQ)")
                    onClicked: {
                        if (root.assessmentStep === 2) root.assessmentStep = 1;
                        else if (root.assessmentStep === 3) root.assessmentStep = 2;
                    }
                    activeFocusOnTab: true
                    Keys.onReturnPressed: clicked()
                    Keys.onSpacePressed: clicked()
                    Accessible.role: Accessible.Button
                    Accessible.name: text

                    background: Rectangle {
                        color: wizardBackBtn.hovered ? Theme.bgCard : Theme.bgInput
                        border.color: wizardBackBtn.activeFocus ? Theme.focusRing : Theme.borderMedium
                        border.width: wizardBackBtn.activeFocus ? 2 : 1
                        radius: Theme.radiusMd
                        implicitHeight: 42
                        implicitWidth: 230
                    }
                    contentItem: Text {
                        text: wizardBackBtn.text
                        color: Theme.textPrimary
                        font.pixelSize: Theme.fontSm
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                // Selection info in Step 1
                Row {
                    visible: root.assessmentStep === 1
                    spacing: 8
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        width: 28
                        height: 28
                        radius: 14
                        color: Theme.primary
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            anchors.centerIn: parent
                            text: root.chosenAppleLevel.toString()
                            color: "#FFFFFF"
                            font.bold: true
                            font.pixelSize: Theme.fontSm
                        }
                    }

                    Text {
                        text: qsTr("Selected Apple Level %1 of 5").arg(root.chosenAppleLevel)
                        color: Theme.textPrimary
                        font.pixelSize: Theme.fontSm
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "• " + qsTr("Keyboard: Press 1-5 to select, Enter to advance")
                        color: Theme.textMuted
                        font.pixelSize: Theme.fontXs
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // Right-aligned Continue Button for Step 1
            Button {
                id: proceedStep1Btn
                visible: root.assessmentStep === 1
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Confirm Selection & Continue to Step 2 (VVIQ) →")
                onClicked: {
                    root.assessmentStep = 2;
                }
                activeFocusOnTab: true
                Keys.onReturnPressed: clicked()
                Keys.onSpacePressed: clicked()
                Accessible.role: Accessible.Button
                Accessible.name: text

                background: Rectangle {
                    color: proceedStep1Btn.down ? Theme.primaryHover : (proceedStep1Btn.hovered ? Theme.primaryLight : Theme.primary)
                    border.color: proceedStep1Btn.activeFocus ? Theme.focusRing : Theme.primaryGlow
                    border.width: proceedStep1Btn.activeFocus ? 2 : 1
                    radius: Theme.radiusMd
                    implicitHeight: 44
                    implicitWidth: 360
                }
                contentItem: Text {
                    text: proceedStep1Btn.text
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
