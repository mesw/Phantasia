import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    property int level: 1
    property string title: ""
    property string description: ""
    property string quote: ""
    property bool isSelected: false

    signal clicked()

    implicitWidth: 260
    implicitHeight: 330
    radius: Theme.radiusMd
    color: isSelected ? Theme.bgCardElevated : Theme.bgCard
    border.color: root.activeFocus ? Theme.focusRing : (isSelected ? Theme.primary : (mouseArea.containsMouse ? Theme.borderBright : Theme.borderMedium))
    border.width: root.activeFocus ? 3 : (isSelected ? 2 : 1)

    activeFocusOnTab: true
    Accessible.role: Accessible.RadioButton
    Accessible.name: qsTr("Level %1: %2").arg(root.level).arg(root.title)
    Accessible.description: root.description

    Keys.onReturnPressed: root.clicked()
    Keys.onSpacePressed: root.clicked()

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.forceActiveFocus();
            root.clicked();
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        // Visual Illustration Box
        Rectangle {
            width: parent.width
            height: 140
            radius: Theme.radiusSm
            color: "#0B0F19" // Dark background for maximum contrast
            clip: true

            Canvas {
                id: illustrationCanvas
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();

                    var cx = width / 2;
                    var cy = height / 2 + 5;
                    var r = 38;

                    function drawApplePath() {
                        ctx.beginPath();
                        ctx.moveTo(cx, cy - r + 10);
                        ctx.bezierCurveTo(cx + 25, cy - r - 4, cx + r + 10, cy - 12, cx + r, cy + 12);
                        ctx.bezierCurveTo(cx + r - 8, cy + r + 4, cx + 18, cy + r + 8, cx, cy + r + 2);
                        ctx.bezierCurveTo(cx - 18, cy + r + 8, cx - r + 8, cy + r + 4, cx - r, cy + 12);
                        ctx.bezierCurveTo(cx - r - 10, cy - 12, cx - 25, cy - r - 4, cx, cy - r + 10);
                        ctx.closePath();
                    }

                    if (root.level === 1) {
                        // Level 1: Photorealistic (Full lighting, gradients, highlights, shadow)
                        // Cast shadow
                        ctx.beginPath();
                        ctx.ellipse(cx + 8, cy + r + 10, r + 8, 10);
                        ctx.fillStyle = "rgba(0, 0, 0, 0.6)";
                        ctx.fill();

                        // Stem
                        ctx.beginPath();
                        ctx.moveTo(cx, cy - r + 10);
                        ctx.quadraticCurveTo(cx - 4, cy - r - 10, cx + 10, cy - r - 18);
                        ctx.lineWidth = 4;
                        ctx.strokeStyle = "#78350F";
                        ctx.lineCap = "round";
                        ctx.stroke();

                        // Leaf
                        ctx.beginPath();
                        ctx.moveTo(cx + 5, cy - r - 6);
                        ctx.quadraticCurveTo(cx + 25, cy - r - 20, cx + 32, cy - r - 8);
                        ctx.quadraticCurveTo(cx + 20, cy - r - 2, cx + 5, cy - r - 6);
                        ctx.fillStyle = "#16A34A";
                        ctx.fill();

                        // Apple body with rich gradient
                        drawApplePath();
                        var grad = ctx.createRadialGradient(cx - 14, cy - 14, 5, cx + 8, cy + 8, r + 14);
                        grad.addColorStop(0.0, "#F87171");
                        grad.addColorStop(0.4, "#DC2626");
                        grad.addColorStop(1.0, "#450A0A");
                        ctx.fillStyle = grad;
                        ctx.fill();

                        // Specular shine
                        ctx.beginPath();
                        ctx.ellipse(cx - 16, cy - 16, 10, 5);
                        ctx.fillStyle = "rgba(255, 255, 255, 0.75)";
                        ctx.fill();

                    } else if (root.level === 2) {
                        // Level 2: Vivid (Good color and shape, minor detail loss)
                        drawApplePath();
                        var grad2 = ctx.createRadialGradient(cx - 10, cy - 10, 5, cx, cy, r);
                        grad2.addColorStop(0.0, "#EF4444");
                        grad2.addColorStop(1.0, "#991B1B");
                        ctx.fillStyle = grad2;
                        ctx.fill();

                        // Simple stem
                        ctx.beginPath();
                        ctx.moveTo(cx, cy - r + 10);
                        ctx.lineTo(cx + 6, cy - r - 12);
                        ctx.lineWidth = 3;
                        ctx.strokeStyle = "#78350F";
                        ctx.stroke();

                    } else if (root.level === 3) {
                        // Level 3: Moderate (Muted color, cartoonish or flat)
                        drawApplePath();
                        ctx.fillStyle = "#B91C1C";
                        ctx.fill();
                        ctx.lineWidth = 2;
                        ctx.strokeStyle = "#7F1D1D";
                        ctx.stroke();

                        // Flat small stem
                        ctx.beginPath();
                        ctx.moveTo(cx, cy - r + 10);
                        ctx.lineTo(cx + 4, cy - r - 8);
                        ctx.lineWidth = 2;
                        ctx.strokeStyle = "#5A3825";
                        ctx.stroke();

                    } else if (root.level === 4) {
                        // Level 4: Faint / Vague (Dim gray translucent outline)
                        drawApplePath();
                        ctx.lineWidth = 1.5;
                        ctx.strokeStyle = "rgba(148, 163, 184, 0.45)"; // Soft gray
                        ctx.stroke();

                        // Faint interior haze
                        ctx.fillStyle = "rgba(148, 163, 184, 0.08)";
                        ctx.fill();

                    } else {
                        // Level 5: Complete Aphantasia (Pitch black / conceptual)
                        ctx.fillStyle = "#020617";
                        ctx.fillRect(0, 0, width, height);

                        // Subtle empty dotted frame
                        ctx.lineWidth = 1;
                        ctx.strokeStyle = "rgba(71, 85, 105, 0.35)";
                        ctx.strokeRect(cx - 30, cy - 30, 60, 60);

                        ctx.fillStyle = "#475569";
                        ctx.font = "italic 13px sans-serif";
                        ctx.textAlign = "center";
                        ctx.fillText(qsTr("Absolute Blackness"), cx, cy + 4);
                    }
                }
            }

            // Level Badge
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 8
                width: 26
                height: 26
                radius: 13
                color: root.isSelected ? Theme.primary : Theme.bgCardElevated
                border.color: Theme.borderBright
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: root.level.toString()
                    color: "#FFFFFF"
                    font.pixelSize: Theme.fontSm
                    font.bold: true
                }
            }

            // Selected checkmark indicator
            Rectangle {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 8
                width: 22
                height: 22
                radius: 11
                color: Theme.emerald
                visible: root.isSelected

                Text {
                    anchors.centerIn: parent
                    text: "✓"
                    color: "#FFFFFF"
                    font.bold: true
                    font.pixelSize: Theme.fontSm
                }
            }
        }

        // Title
        Text {
            text: root.title
            color: root.isSelected ? Theme.primaryLight : Theme.textPrimary
            font.pixelSize: Theme.fontMd
            font.bold: true
            width: parent.width
            wrapMode: Text.WordWrap
        }

        // Description
        Text {
            text: root.description
            color: Theme.textSecondary
            font.pixelSize: Theme.fontXs
            lineHeight: 1.2
            width: parent.width
            wrapMode: Text.WordWrap
            maximumLineCount: 3
            elide: Text.ElideRight
        }

        // Quote
        Text {
            text: root.quote
            color: Theme.textMuted
            font.pixelSize: Theme.fontXs - 1
            font.italic: true
            width: parent.width
            wrapMode: Text.WordWrap
            maximumLineCount: 2
            elide: Text.ElideRight
        }
    }
}
