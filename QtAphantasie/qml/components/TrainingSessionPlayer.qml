import QtQuick
import QtQuick.Controls

Item {
    id: root

    property int week: 1
    property int day: 1

    signal sessionCompleted()
    signal exitRequested()

    implicitWidth: 880
    implicitHeight: 720

    property var sessionData: trainingEngine.getSessionDetails(root.week, root.day)
    property int currentPhase: 1 // 1: Breath & Relaxation, 2: Guided Exercise, 3: Reflection

    property int sessionRating: 3
    property string sessionNotes: ""
    property int exerciseRemainingSec: sessionData.exerciseDuration || 480
    property bool exerciseTimerRunning: true

    Timer {
        id: exerciseCountdown
        interval: 1000
        repeat: true
        running: (root.currentPhase === 2) && root.exerciseTimerRunning && root.exerciseRemainingSec > 0
        onTriggered: {
            root.exerciseRemainingSec--;
            if (root.exerciseRemainingSec <= 0) {
                root.currentPhase = 3;
            }
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16

        // Top Header Bar: Title, Week/Day, Phase Indicators, Exit
        Row {
            width: parent.width
            spacing: 14

            Column {
                width: parent.width - 200
                spacing: 2

                Row {
                    spacing: 8
                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: root.sessionData.themeColor || Theme.primary
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: qsTr("Week %1, Day %2 • %3").arg(root.week).arg(root.day).arg(root.sessionData.weekTitle || "")
                        color: Theme.textMuted
                        font.pixelSize: Theme.fontXs
                    }
                }

                Text {
                    text: root.sessionData.title || ""
                    color: Theme.textPrimary
                    font.pixelSize: Theme.fontLg
                    font.bold: true
                }
            }

            Button {
                text: qsTr("Exit Session")
                onClicked: root.exitRequested()
                background: Rectangle {
                    color: "transparent"
                    border.color: Theme.borderMedium
                    radius: Theme.radiusMd
                    implicitHeight: 34
                    implicitWidth: 110
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

        // 3-Phase Stepper Tabs
        Row {
            width: parent.width
            spacing: 8

            Repeater {
                model: [
                    { id: 1, label: qsTr("1. Breath Calibration (2m)") },
                    { id: 2, label: qsTr("2. Guided Exercise (8m)") },
                    { id: 3, label: qsTr("3. Reflection & Rating (2m)") }
                ]

                Rectangle {
                    width: (parent.width - 16) / 3
                    height: 36
                    radius: Theme.radiusSm
                    color: (root.currentPhase === modelData.id) ? Theme.primary : Theme.bgCard
                    border.color: (root.currentPhase === modelData.id) ? Theme.primaryLight : Theme.borderDim
                    border.width: 1

                    Row {
                        anchors.centerIn: parent
                        spacing: 6
                        Text {
                            text: (root.currentPhase > modelData.id) ? "✓" : modelData.id.toString()
                            color: (root.currentPhase === modelData.id) ? "#FFFFFF" : Theme.textMuted
                            font.bold: true
                            font.pixelSize: Theme.fontXs
                        }
                        Text {
                            text: modelData.label
                            color: (root.currentPhase === modelData.id) ? "#FFFFFF" : Theme.textSecondary
                            font.bold: (root.currentPhase === modelData.id)
                            font.pixelSize: Theme.fontXs
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.currentPhase = modelData.id
                    }
                }
            }
        }

        // ==========================================
        // PHASE 1: CALIBRATING BREATH & RELAXATION
        // ==========================================
        Item {
            width: parent.width
            height: parent.height - 120
            visible: root.currentPhase === 1

            Column {
                anchors.centerIn: parent
                spacing: 24

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.sessionData.breathInstructions || ""
                    color: Theme.textSecondary
                    font.pixelSize: Theme.fontSm
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    width: 580
                    lineHeight: 1.3
                }

                BreathingPacer {
                    anchors.horizontalCenter: parent.horizontalCenter
                    onCompleted: {
                        root.currentPhase = 2;
                    }
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Proceed to Exercise (Phase 2) →")
                    onClicked: root.currentPhase = 2
                    background: Rectangle {
                        color: Theme.primary
                        radius: Theme.radiusMd
                        implicitHeight: 42
                        implicitWidth: 260
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

        // ==========================================
        // PHASE 2: GUIDED EXERCISE
        // ==========================================
        Item {
            width: parent.width
            height: parent.height - 120
            visible: root.currentPhase === 2

            Flickable {
                anchors.fill: parent
                contentWidth: width
                contentHeight: exerciseCol.height + 40
                clip: true

                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                Column {
                    id: exerciseCol
                    width: parent.width
                    spacing: 16

                    // Instructions Card
                    Rectangle {
                        width: parent.width
                        height: instrCol.height + 24
                        radius: Theme.radiusMd
                        color: Theme.bgCard
                        border.color: Theme.borderMedium
                        border.width: 1

                        Column {
                            id: instrCol
                            anchors.top: parent.top
                            anchors.topMargin: 12
                            anchors.left: parent.left
                            anchors.leftMargin: 16
                            width: parent.width - 32
                            spacing: 8

                            Row {
                                spacing: 10
                                Text {
                                    text: "🎯"
                                    font.pixelSize: 14
                                }
                                Text {
                                    text: root.sessionData.focus || ""
                                    color: Theme.textPrimary
                                    font.pixelSize: Theme.fontSm
                                    font.bold: true
                                }
                            }

                            Text {
                                text: root.sessionData.exerciseInstructions || ""
                                color: Theme.textSecondary
                                font.pixelSize: Theme.fontSm
                                wrapMode: Text.WordWrap
                                width: parent.width
                                lineHeight: 1.35
                            }

                            Text {
                                text: qsTr("Scientific Basis: %1").arg(root.sessionData.scientificNote || "")
                                color: Theme.textMuted
                                font.pixelSize: Theme.fontXs
                                font.italic: true
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }
                        }
                    }

                    // Interactive Tool Switcher Area
                    Item {
                        width: parent.width
                        height: 380

                        // Mode 1: Afterimage Viewer (Week 2)
                        AfterimageViewer {
                            anchors.centerIn: parent
                            visible: (root.sessionData.exerciseMode === "afterimage_cross" ||
                                      root.sessionData.exerciseMode === "afterimage_rings" ||
                                      root.sessionData.exerciseMode === "afterimage_shapes")
                            shapeMode: {
                                if (root.sessionData.exerciseMode === "afterimage_rings") return "rings";
                                if (root.sessionData.exerciseMode === "afterimage_shapes") return "shapes";
                                return "cross";
                            }
                            onAfterimageLogged: function(sec) {
                                root.sessionNotes += (root.sessionNotes ? "\n" : "") + qsTr("Logged afterimage duration: %1s").arg(sec);
                            }
                        }

                        // Mode 2: Mental Rotation Viewer (Week 4)
                        MentalRotationViewer {
                            anchors.centerIn: parent
                            visible: (root.sessionData.exerciseMode === "mental_rotation_2d" ||
                                      root.sessionData.exerciseMode === "mental_rotation_3d")
                            mode: (root.sessionData.exerciseMode === "mental_rotation_2d") ? "2d" : "3d"
                        }

                        // Mode 3: Layer Assembly Viewer (Week 3)
                        LayerAssemblyViewer {
                            anchors.centerIn: parent
                            visible: (root.sessionData.exerciseMode === "layer_assembly")
                        }

                        // Mode 4: Contemplative Sensory Scaffolding & Dynamic Scene Player (Week 1, 5, 6)
                        Rectangle {
                            anchors.fill: parent
                            visible: (root.sessionData.exerciseMode !== "afterimage_cross" &&
                                      root.sessionData.exerciseMode !== "afterimage_rings" &&
                                      root.sessionData.exerciseMode !== "afterimage_shapes" &&
                                      root.sessionData.exerciseMode !== "mental_rotation_2d" &&
                                      root.sessionData.exerciseMode !== "mental_rotation_3d" &&
                                      root.sessionData.exerciseMode !== "layer_assembly")
                            color: Theme.bgInput
                            radius: Theme.radiusMd
                            border.color: Theme.borderMedium
                            border.width: 1

                            Column {
                                anchors.centerIn: parent
                                spacing: 20
                                width: parent.width - 60

                                Rectangle {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: 70
                                    height: 70
                                    radius: 35
                                    color: Theme.bgCardElevated
                                    border.color: Theme.primary
                                    border.width: 2

                                    Text {
                                        anchors.centerIn: parent
                                        text: (root.sessionData.exerciseMode === "spatial_tactile") ? "🖐" : ((root.sessionData.exerciseMode === "affective_nature") ? "🌿" : "🧭")
                                        font.pixelSize: 32
                                    }
                                }

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: qsTr("Guided Neurocognitive Contemplation")
                                    color: Theme.textPrimary
                                    font.pixelSize: Theme.fontMd
                                    font.bold: true
                                }

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: qsTr("Close your eyes or soften your gaze. Work through the step-by-step instructions above. Avoid forcing mental imagery; focus attentively on physical textures, spatial orientations, or somatic feelings.")
                                    color: Theme.textSecondary
                                    font.pixelSize: Theme.fontSm
                                    horizontalAlignment: Text.AlignHCenter
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                    lineHeight: 1.3
                                }
                            }
                        }
                    }

                    // Bottom Timer & Next Action Bar
                    Row {
                        width: parent.width
                        spacing: 16

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr("Exercise Time Remaining: %1:%2").arg(Math.floor(root.exerciseRemainingSec / 60)).arg((root.exerciseRemainingSec % 60 < 10 ? "0" : "") + (root.exerciseRemainingSec % 60))
                            color: Theme.emeraldLight
                            font.pixelSize: Theme.fontSm
                            font.bold: true
                        }

                        Button {
                            text: root.exerciseTimerRunning ? qsTr("Pause") : qsTr("Resume")
                            onClicked: root.exerciseTimerRunning = !root.exerciseTimerRunning
                            background: Rectangle {
                                color: Theme.bgCardElevated
                                border.color: Theme.borderMedium
                                radius: Theme.radiusSm
                                implicitHeight: 32
                                implicitWidth: 80
                            }
                            contentItem: Text {
                                text: parent.text
                                color: Theme.textPrimary
                                font.pixelSize: Theme.fontXs
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Item { width: Math.max(10, parent.width - 550); height: 1 }

                        Button {
                            text: qsTr("Proceed to Reflection (Phase 3) →")
                            onClicked: root.currentPhase = 3
                            background: Rectangle {
                                color: Theme.primary
                                radius: Theme.radiusMd
                                implicitHeight: 38
                                implicitWidth: 260
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
        }

        // ==========================================
        // PHASE 3: REFLECTION & RATING
        // ==========================================
        Item {
            width: parent.width
            height: parent.height - 120
            visible: root.currentPhase === 3

            Flickable {
                anchors.fill: parent
                contentWidth: width
                contentHeight: reflectCol.height + 40
                clip: true

                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                Column {
                    id: reflectCol
                    width: parent.width
                    spacing: 20

                    // Rating Section
                    Rectangle {
                        width: parent.width
                        height: 140
                        radius: Theme.radiusMd
                        color: Theme.bgCard
                        border.color: Theme.borderMedium
                        border.width: 1

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 12

                            Text {
                                text: qsTr("1. How vivid, stable, or clear was your mental experience today?")
                                color: Theme.textPrimary
                                font.pixelSize: Theme.fontSm
                                font.bold: true
                            }

                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 14

                                Repeater {
                                    model: [
                                        { val: 1, label: qsTr("1: No sensation") },
                                        { val: 2, label: qsTr("2: Dim / Vague") },
                                        { val: 3, label: qsTr("3: Moderate") },
                                        { val: 4, label: qsTr("4: Clear / Vivid") },
                                        { val: 5, label: qsTr("5: Lifelike") }
                                    ]

                                    Rectangle {
                                        id: starBtn
                                        width: 130
                                        height: 48
                                        radius: Theme.radiusMd
                                        property bool isSelected: (root.sessionRating === modelData.val)
                                        color: isSelected ? Theme.primary : Theme.bgInput
                                        border.color: isSelected ? Theme.primaryLight : Theme.borderMedium
                                        border.width: isSelected ? 2 : 1

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: root.sessionRating = modelData.val
                                        }

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.label
                                            color: starBtn.isSelected ? "#FFFFFF" : Theme.textSecondary
                                            font.pixelSize: Theme.fontXs
                                            font.bold: starBtn.isSelected
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Sensory Notes Section
                    Rectangle {
                        width: parent.width
                        height: 180
                        radius: Theme.radiusMd
                        color: Theme.bgCard
                        border.color: Theme.borderMedium
                        border.width: 1

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 10

                            Text {
                                text: qsTr("2. Sensory Reflection & Modality Notes:")
                                color: Theme.textPrimary
                                font.pixelSize: Theme.fontSm
                                font.bold: true
                            }

                            Text {
                                text: qsTr("Which sensory anchor felt most effective (e.g. tactile coldness, spatial coordinates, acoustic echo, word facts)?")
                                color: Theme.textMuted
                                font.pixelSize: Theme.fontXs
                            }

                            ScrollView {
                                width: parent.width
                                height: 80

                                TextArea {
                                    id: notesInput
                                    placeholderText: qsTr("Enter your observations here...")
                                    text: root.sessionNotes
                                    onTextChanged: root.sessionNotes = text
                                    color: Theme.textPrimary
                                    font.pixelSize: Theme.fontSm
                                    wrapMode: Text.WordWrap
                                    background: Rectangle {
                                        color: Theme.bgInput
                                        radius: Theme.radiusSm
                                        border.color: Theme.borderMedium
                                        border.width: 1
                                    }
                                }
                            }
                        }
                    }

                    // Save Button
                    Button {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Save Session & Complete Day %1 ✓").arg(root.day)
                        onClicked: {
                            storageManager.saveTrainingSession(root.week, root.day, root.sessionRating, root.sessionNotes, 600);
                            root.sessionCompleted();
                        }
                        background: Rectangle {
                            color: Theme.emerald
                            radius: Theme.radiusMd
                            implicitHeight: 48
                            implicitWidth: 340
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "#FFFFFF"
                            font.pixelSize: Theme.fontMd
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }
    }
}
