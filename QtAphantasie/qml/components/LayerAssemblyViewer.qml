import QtQuick
import QtQuick.Controls

Item {
    id: root

    property bool showContour: true
    property bool showColor: true
    property bool showTexture: true
    property bool showLighting: true

    implicitWidth: 420
    implicitHeight: 380

    Rectangle {
        anchors.fill: parent
        color: Theme.bgInput
        radius: Theme.radiusMd
        border.color: Theme.borderMedium
        border.width: 1

        Canvas {
            id: canvas
            anchors.fill: parent
            anchors.bottomMargin: 70

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();

                var cx = width / 2;
                var cy = height / 2 - 10;
                var r = 65;

                // 1. Layer 4: Ground Cast Shadow
                if (root.showLighting) {
                    ctx.save();
                    ctx.beginPath();
                    ctx.ellipse(cx + 10, cy + r + 15, r + 10, 16);
                    ctx.fillStyle = "rgba(0, 0, 0, 0.45)";
                    ctx.fill();
                    ctx.restore();
                }

                // Apple body path
                function traceApple() {
                    ctx.beginPath();
                    ctx.moveTo(cx, cy - r + 15);
                    // top right curve
                    ctx.bezierCurveTo(cx + 40, cy - r - 5, cx + r + 15, cy - 20, cx + r, cy + 20);
                    // bottom right
                    ctx.bezierCurveTo(cx + r - 10, cy + r + 5, cx + 25, cy + r + 15, cx, cy + r + 5);
                    // bottom left
                    ctx.bezierCurveTo(cx - 25, cy + r + 15, cx - r + 10, cy + r + 5, cx - r, cy + 20);
                    // top left curve
                    ctx.bezierCurveTo(cx - r - 15, cy - 20, cx - 40, cy - r - 5, cx, cy - r + 15);
                    ctx.closePath();
                }

                // 2. Layer 2: Flat Color Fill
                if (root.showColor) {
                    ctx.save();
                    traceApple();
                    ctx.fillStyle = "#DC2626"; // Vibrant Crimson Red
                    ctx.fill();
                    ctx.restore();
                }

                // 3. Layer 3: Texture & Stem & Leaf
                if (root.showTexture) {
                    ctx.save();
                    // Stem
                    ctx.beginPath();
                    ctx.moveTo(cx, cy - r + 15);
                    ctx.quadraticCurveTo(cx - 5, cy - r - 15, cx + 15, cy - r - 25);
                    ctx.lineWidth = 6;
                    ctx.strokeStyle = "#78350F"; // Brown wood stem
                    ctx.lineCap = "round";
                    ctx.stroke();

                    // Green Leaf
                    ctx.beginPath();
                    ctx.moveTo(cx + 8, cy - r - 12);
                    ctx.quadraticCurveTo(cx + 35, cy - r - 30, cx + 45, cy - r - 15);
                    ctx.quadraticCurveTo(cx + 30, cy - r - 5, cx + 8, cy - r - 12);
                    ctx.fillStyle = "#16A34A";
                    ctx.fill();
                    ctx.restore();
                }

                // 4. Layer 4: Lighting & Shading
                if (root.showLighting && root.showColor) {
                    ctx.save();
                    traceApple();
                    ctx.clip();

                    // Shading gradient from top-left (light) to bottom-right (shadow)
                    var grad = ctx.createRadialGradient(cx - 25, cy - 25, 10, cx + 15, cy + 15, r + 20);
                    grad.addColorStop(0.0, "rgba(255, 255, 255, 0.45)");
                    grad.addColorStop(0.4, "rgba(255, 255, 255, 0.0)");
                    grad.addColorStop(1.0, "rgba(0, 0, 0, 0.55)");

                    ctx.fillStyle = grad;
                    ctx.fill();

                    // Specular highlight gleam
                    ctx.beginPath();
                    ctx.ellipse(cx - 28, cy - 28, 16, 9);
                    ctx.fillStyle = "rgba(255, 255, 255, 0.75)";
                    ctx.fill();

                    ctx.restore();
                }

                // 5. Layer 1: Boundary Outline
                if (root.showContour) {
                    ctx.save();
                    traceApple();
                    ctx.lineWidth = 3;
                    ctx.strokeStyle = (root.showColor) ? "#7F1D1D" : "#F8FAFC";
                    ctx.stroke();
                    ctx.restore();
                }
            }
        }

        // Layer Toggle Buttons Bar
        Row {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 14
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            // L1
            Button {
                id: btnL1
                text: qsTr("1. Outline")
                checkable: true
                checked: root.showContour
                onToggled: { root.showContour = checked; canvas.requestPaint(); }
                activeFocusOnTab: true
                Keys.onReturnPressed: toggle()
                Keys.onSpacePressed: toggle()
                Accessible.role: Accessible.CheckBox
                Accessible.name: text

                background: Rectangle {
                    color: btnL1.checked ? Theme.primary : Theme.bgCardElevated
                    border.color: btnL1.activeFocus ? Theme.focusRing : Theme.borderBright
                    border.width: btnL1.activeFocus ? 2 : 1
                    radius: Theme.radiusSm
                    implicitHeight: 34
                    implicitWidth: 92
                }
                contentItem: Text {
                    text: btnL1.text
                    color: "#FFFFFF"
                    font.pixelSize: Theme.fontXs
                    font.bold: btnL1.checked
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // L2
            Button {
                id: btnL2
                text: qsTr("2. Color")
                checkable: true
                checked: root.showColor
                onToggled: { root.showColor = checked; canvas.requestPaint(); }
                activeFocusOnTab: true
                Keys.onReturnPressed: toggle()
                Keys.onSpacePressed: toggle()
                Accessible.role: Accessible.CheckBox
                Accessible.name: text

                background: Rectangle {
                    color: btnL2.checked ? Theme.rose : Theme.bgCardElevated
                    border.color: btnL2.activeFocus ? Theme.focusRing : Theme.borderBright
                    border.width: btnL2.activeFocus ? 2 : 1
                    radius: Theme.radiusSm
                    implicitHeight: 34
                    implicitWidth: 92
                }
                contentItem: Text {
                    text: btnL2.text
                    color: "#FFFFFF"
                    font.pixelSize: Theme.fontXs
                    font.bold: btnL2.checked
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // L3
            Button {
                id: btnL3
                text: qsTr("3. Texture")
                checkable: true
                checked: root.showTexture
                onToggled: { root.showTexture = checked; canvas.requestPaint(); }
                activeFocusOnTab: true
                Keys.onReturnPressed: toggle()
                Keys.onSpacePressed: toggle()
                Accessible.role: Accessible.CheckBox
                Accessible.name: text

                background: Rectangle {
                    color: btnL3.checked ? Theme.emerald : Theme.bgCardElevated
                    border.color: btnL3.activeFocus ? Theme.focusRing : Theme.borderBright
                    border.width: btnL3.activeFocus ? 2 : 1
                    radius: Theme.radiusSm
                    implicitHeight: 34
                    implicitWidth: 92
                }
                contentItem: Text {
                    text: btnL3.text
                    color: "#FFFFFF"
                    font.pixelSize: Theme.fontXs
                    font.bold: btnL3.checked
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // L4
            Button {
                id: btnL4
                text: qsTr("4. Light")
                checkable: true
                checked: root.showLighting
                onToggled: { root.showLighting = checked; canvas.requestPaint(); }
                activeFocusOnTab: true
                Keys.onReturnPressed: toggle()
                Keys.onSpacePressed: toggle()
                Accessible.role: Accessible.CheckBox
                Accessible.name: text

                background: Rectangle {
                    color: btnL4.checked ? Theme.amber : Theme.bgCardElevated
                    border.color: btnL4.activeFocus ? Theme.focusRing : Theme.borderBright
                    border.width: btnL4.activeFocus ? 2 : 1
                    radius: Theme.radiusSm
                    implicitHeight: 34
                    implicitWidth: 92
                }
                contentItem: Text {
                    text: btnL4.text
                    color: "#FFFFFF"
                    font.pixelSize: Theme.fontXs
                    font.bold: btnL4.checked
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
