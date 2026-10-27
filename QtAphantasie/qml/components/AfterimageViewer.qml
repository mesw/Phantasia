import QtQuick
import QtQuick.Controls

Item {
    id: root

    property string shapeMode: "cross" // "cross", "rings", "shapes"
    property int fixationSeconds: 30
    property int remainingFixation: fixationSeconds
    property bool isFixating: true
    property int afterimageElapsedSec: 0

    signal afterimageLogged(int durationSeconds)

    implicitWidth: 460
    implicitHeight: 460

    Timer {
        id: fixationTimer
        interval: 1000
        repeat: true
        running: root.isFixating && root.remainingFixation > 0
        onTriggered: {
            root.remainingFixation--;
            if (root.remainingFixation <= 0) {
                root.isFixating = false;
                root.afterimageElapsedSec = 0;
            }
        }
    }

    Timer {
        id: afterimageTimer
        interval: 1000
        repeat: true
        running: !root.isFixating
        onTriggered: {
            root.afterimageElapsedSec++;
        }
    }

    // High-contrast stimulus container
    Rectangle {
        id: displayBox
        anchors.fill: parent
        color: "#000000" // Strict pitch black for maximum retinal contrast
        radius: Theme.radiusMd
        border.color: root.isFixating ? Theme.primary : Theme.emerald
        border.width: 2
        clip: true

        // 1. Fixation Stimulus State
        Item {
            anchors.fill: parent
            visible: root.isFixating

            // Shape: Monochromatic Cross
            Item {
                anchors.centerIn: parent
                width: 220
                height: 220
                visible: root.shapeMode === "cross"

                Rectangle {
                    anchors.centerIn: parent
                    width: 40
                    height: 220
                    color: "#FFFFFF"
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: 220
                    height: 40
                    color: "#FFFFFF"
                }

                // Central red fixation point
                Rectangle {
                    anchors.centerIn: parent
                    width: 10
                    height: 10
                    radius: 5
                    color: "#FF0000"
                }
            }

            // Shape: Concentric Rings
            Canvas {
                id: ringsCanvas
                anchors.centerIn: parent
                width: 260
                height: 260
                visible: root.shapeMode === "rings"
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    var cx = width / 2;
                    var cy = height / 2;
                    var numRings = 6;
                    var ringWidth = 20;

                    for (var i = numRings; i >= 1; --i) {
                        ctx.beginPath();
                        ctx.arc(cx, cy, i * ringWidth, 0, 2 * Math.PI);
                        ctx.fillStyle = (i % 2 === 0) ? "#FFFFFF" : "#000000";
                        ctx.fill();
                    }

                    // Red center dot
                    ctx.beginPath();
                    ctx.arc(cx, cy, 5, 0, 2 * Math.PI);
                    ctx.fillStyle = "#FF0000";
                    ctx.fill();
                }
            }

            // Shape: Triangle / Chromatic Circle
            Canvas {
                id: triangleCanvas
                anchors.centerIn: parent
                width: 240
                height: 240
                visible: root.shapeMode === "shapes"
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    var cx = width / 2;
                    var cy = height / 2;

                    // Large vibrant saturated red disc (induces complementary cyan afterimage)
                    ctx.beginPath();
                    ctx.arc(cx, cy, 90, 0, 2 * Math.PI);
                    ctx.fillStyle = "#EF4444";
                    ctx.fill();

                    // Equilateral white triangle inside
                    ctx.beginPath();
                    ctx.moveTo(cx, cy - 50);
                    ctx.lineTo(cx + 45, cy + 35);
                    ctx.lineTo(cx - 45, cy + 35);
                    ctx.closePath();
                    ctx.fillStyle = "#FFFFFF";
                    ctx.fill();

                    // Central small dark fixation point
                    ctx.beginPath();
                    ctx.arc(cx, cy, 4, 0, 2 * Math.PI);
                    ctx.fillStyle = "#000000";
                    ctx.fill();
                }
            }

            // Fixation Timer Overlay at Top
            Rectangle {
                anchors.top: parent.top
                anchors.topMargin: 16
                anchors.horizontalCenter: parent.horizontalCenter
                width: 260
                height: 38
                radius: 19
                color: "#1E293B"
                border.color: Theme.borderBright
                border.width: 1

                Row {
                    anchors.centerIn: parent
                    spacing: 8
                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: "#EF4444"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: qsTr("Fixate strictly on center dot: %1s").arg(root.remainingFixation)
                        color: "#FFFFFF"
                        font.pixelSize: Theme.fontSm
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        // 2. Closed-Eye Afterimage Observation State
        Column {
            anchors.centerIn: parent
            spacing: 20
            width: parent.width - 60
            visible: !root.isFixating

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Close Your Eyes Now")
                color: Theme.emeraldLight
                font.pixelSize: Theme.fontTitle
                font.bold: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Observe the retinal afterimage on your dark visual field.\nNote its shape, complementary colors, and contour stability.")
                color: "#CBD5E1"
                font.pixelSize: Theme.fontMd
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                width: parent.width
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 140
                height: 50
                radius: 25
                color: "#1E293B"
                border.color: Theme.emerald
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: root.afterimageElapsedSec + "s"
                    color: Theme.emeraldLight
                    font.pixelSize: Theme.fontXl
                    font.bold: true
                }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 12

                Button {
                    text: qsTr("Afterimage Faded (Log %1s)").arg(root.afterimageElapsedSec)
                    onClicked: {
                        root.afterimageLogged(root.afterimageElapsedSec);
                    }
                    background: Rectangle {
                        color: Theme.emerald
                        radius: Theme.radiusMd
                        implicitHeight: 40
                        implicitWidth: 200
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "#FFFFFF"
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Button {
                    text: qsTr("Restart Fixation")
                    onClicked: {
                        root.remainingFixation = root.fixationSeconds;
                        root.isFixating = true;
                    }
                    background: Rectangle {
                        color: Theme.bgCardElevated
                        border.color: Theme.borderBright
                        radius: Theme.radiusMd
                        implicitHeight: 40
                        implicitWidth: 140
                    }
                    contentItem: Text {
                        text: parent.text
                        color: Theme.textPrimary
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
}
