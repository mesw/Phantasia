import QtQuick
import QtQuick.Controls

Item {
    id: root

    property int totalSeconds: 120
    property int remainingSeconds: totalSeconds
    property bool running: true

    signal completed()

    implicitWidth: 320
    implicitHeight: 320

    property int cyclePhase: 0 // 0: Inhale (4s), 1: Hold (4s), 2: Exhale (4s), 3: Hold (4s)
    property int phaseTimerSec: 4

    Timer {
        id: secondTimer
        interval: 1000
        repeat: true
        running: root.running && root.remainingSeconds > 0
        onTriggered: {
            root.remainingSeconds--;
            root.phaseTimerSec--;

            if (root.phaseTimerSec <= 0) {
                root.cyclePhase = (root.cyclePhase + 1) % 4;
                root.phaseTimerSec = 4;
            }

            if (root.remainingSeconds <= 0) {
                root.completed();
            }
        }
    }

    // Outer glow ring
    Rectangle {
        id: glowRing
        anchors.centerIn: parent
        width: innerCircle.width + 40
        height: width
        radius: width / 2
        color: "transparent"
        border.color: Theme.primaryLight
        border.width: 2
        opacity: (root.cyclePhase === 0 || root.cyclePhase === 1) ? 0.6 : 0.2

        Behavior on opacity {
            NumberAnimation { duration: 1500; easing.type: Easing.InOutQuad }
        }
    }

    // Central pulsing breathing circle
    Rectangle {
        id: innerCircle
        anchors.centerIn: parent
        width: (root.cyclePhase === 0 || root.cyclePhase === 1) ? 220 : 130
        height: width
        radius: width / 2

        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: (root.cyclePhase === 0 || root.cyclePhase === 1) ? Theme.primaryLight : Theme.accent
            }
            GradientStop {
                position: 1.0
                color: (root.cyclePhase === 0 || root.cyclePhase === 1) ? Theme.primaryHover : Theme.bgCardElevated
            }
        }

        Behavior on width {
            NumberAnimation {
                duration: 4000
                easing.type: Easing.InOutSine
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 6

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: {
                    switch (root.cyclePhase) {
                    case 0: return qsTr("Inhale");
                    case 1: return qsTr("Hold");
                    case 2: return qsTr("Exhale");
                    case 3: return qsTr("Hold");
                    default: return "";
                    }
                }
                color: "#FFFFFF"
                font.pixelSize: Theme.fontXl
                font.bold: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.phaseTimerSec + "s"
                color: "#E2E8F0"
                font.pixelSize: Theme.fontLg
                font.weight: Font.DemiBold
            }
        }
    }

    // Overall session time remaining bar
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: 240
        height: 6
        radius: 3
        color: Theme.borderDim

        Rectangle {
            height: parent.height
            radius: 3
            width: parent.width * ((root.totalSeconds - root.remainingSeconds) / Math.max(1, root.totalSeconds))
            color: Theme.emeraldLight

            Behavior on width {
                NumberAnimation { duration: 250 }
            }
        }
    }

    Text {
        anchors.top: parent.bottom
        anchors.topMargin: 12
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Remaining: %1:%2").arg(Math.floor(root.remainingSeconds / 60)).arg((root.remainingSeconds % 60 < 10 ? "0" : "") + (root.remainingSeconds % 60))
        color: Theme.textSecondary
        font.pixelSize: Theme.fontSm
    }
}
