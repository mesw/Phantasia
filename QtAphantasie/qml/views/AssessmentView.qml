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

    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16

        // Header Title / Stepper
        Row {
            width: parent.width
            spacing: 16

            Column {
                width: parent.width - 200
                spacing: 2

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
                }
            }
        }

        // ==========================================
        // STEP 1: THE APPLE TEST
        // ==========================================
        Item {
            width: parent.width
            height: parent.height - 80
            visible: root.assessmentStep === 1

            Flickable {
                anchors.fill: parent
                contentWidth: width
                contentHeight: appleCol.height + 40
                clip: true

                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                Column {
                    id: appleCol
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    spacing: 20

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

                    // Proceed Button
                    Button {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Confirm Selection & Continue to Full VVIQ Evaluation (Step 2) →")
                        onClicked: {
                            root.assessmentStep = 2;
                        }
                        background: Rectangle {
                            color: Theme.primary
                            radius: Theme.radiusMd
                            implicitHeight: 46
                            implicitWidth: 440
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
            }
        }

        // ==========================================
        // STEP 2: STANDARDIZED VVIQ EVALUATION
        // ==========================================
        Item {
            width: parent.width
            height: parent.height - 80
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

        // ==========================================
        // STEP 3: MULTI-SENSORY PROFILING
        // ==========================================
        Item {
            width: parent.width
            height: parent.height - 80
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

        // ==========================================
        // STEP 4: DIAGNOSTIC REPORT
        // ==========================================
        Item {
            width: parent.width
            height: parent.height - 80
            visible: root.assessmentStep === 4

            DiagnosticReport {
                anchors.centerIn: parent
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
}
