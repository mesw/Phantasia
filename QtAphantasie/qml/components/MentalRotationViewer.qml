import QtQuick
import QtQuick.Controls

Item {
    id: root

    property string mode: "3d" // "2d" or "3d"
    property real angleY: 0
    property real angleX: 25
    property bool autoSpin: false

    implicitWidth: 420
    implicitHeight: 380

    Timer {
        interval: 16
        repeat: true
        running: root.autoSpin
        onTriggered: {
            root.angleY = (root.angleY + 1.0);
            if (root.angleY >= 360) root.angleY = 0;
            canvas.requestPaint();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.bgInput
        radius: Theme.radiusMd
        border.color: Theme.borderMedium
        border.width: 1

        Canvas {
            id: canvas
            anchors.fill: parent
            anchors.bottomMargin: 80

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();

                var cx = width / 2;
                var cy = height / 2;

                if (root.mode === "2d") {
                    // 2D Rotation: Letter F
                    ctx.save();
                    ctx.translate(cx, cy);
                    ctx.rotate(root.angleY * Math.PI / 180.0);

                    ctx.fillStyle = Theme.primaryLight;
                    ctx.font = "bold 90px sans-serif";
                    ctx.textAlign = "center";
                    ctx.textBaseline = "middle";
                    ctx.fillText("F", 0, 0);

                    // Orientation marker
                    ctx.beginPath();
                    ctx.arc(0, -60, 6, 0, 2 * Math.PI);
                    ctx.fillStyle = Theme.emerald;
                    ctx.fill();

                    ctx.restore();
                } else {
                    // 3D Isometric Wireframe Cube
                    var radY = root.angleY * Math.PI / 180.0;
                    var radX = root.angleX * Math.PI / 180.0;
                    var size = 70;

                    // 8 cube vertices
                    var vertices = [
                        [-size, -size, -size],
                        [ size, -size, -size],
                        [ size,  size, -size],
                        [-size,  size, -size],
                        [-size, -size,  size],
                        [ size, -size,  size],
                        [ size,  size,  size],
                        [-size,  size,  size]
                    ];

                    // 12 edges connecting pairs of vertices
                    var edges = [
                        [0, 1], [1, 2], [2, 3], [3, 0], // back face
                        [4, 5], [5, 6], [6, 7], [7, 4], // front face
                        [0, 4], [1, 5], [2, 6], [3, 7]  // connecting edges
                    ];

                    var projected = [];

                    for (var i = 0; i < vertices.length; ++i) {
                        var x = vertices[i][0];
                        var y = vertices[i][1];
                        var z = vertices[i][2];

                        // Rotate around Y
                        var x1 = x * Math.cos(radY) + z * Math.sin(radY);
                        var z1 = -x * Math.sin(radY) + z * Math.cos(radY);

                        // Rotate around X
                        var y2 = y * Math.cos(radX) - z1 * Math.sin(radX);
                        var z2 = y * Math.sin(radX) + z1 * Math.cos(radX);

                        // Weak perspective projection
                        var fov = 350;
                        var scale = fov / (fov + z2 + 100);
                        var px = cx + x1 * scale;
                        var py = cy + y2 * scale;

                        projected.push({ x: px, y: py, z: z2 });
                    }

                    // Draw edges
                    ctx.strokeStyle = Theme.primaryLight;
                    ctx.lineWidth = 3;
                    ctx.lineCap = "round";

                    for (var e = 0; e < edges.length; ++e) {
                        var p1 = projected[edges[e][0]];
                        var p2 = projected[edges[e][1]];

                        ctx.beginPath();
                        ctx.moveTo(p1.x, p1.y);
                        ctx.lineTo(p2.x, p2.y);
                        ctx.stroke();
                    }

                    // Draw vertices
                    for (var v = 0; v < projected.length; ++v) {
                        ctx.beginPath();
                        ctx.arc(projected[v].x, projected[v].y, (v === 4) ? 7 : 4, 0, 2 * Math.PI);
                        ctx.fillStyle = (v === 4) ? Theme.rose : Theme.cyan;
                        ctx.fill();
                    }
                }
            }
        }

        // Bottom Controls
        Column {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 14
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 40
            spacing: 8

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16

                Text {
                    text: qsTr("Rotation: %1°").arg(Math.round(root.angleY))
                    color: Theme.textPrimary
                    font.pixelSize: Theme.fontSm
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Button {
                    text: root.autoSpin ? qsTr("Pause Spin") : qsTr("Auto Spin")
                    onClicked: {
                        root.autoSpin = !root.autoSpin;
                    }
                    background: Rectangle {
                        color: root.autoSpin ? Theme.amber : Theme.bgCardElevated
                        border.color: Theme.borderBright
                        radius: Theme.radiusSm
                        implicitHeight: 28
                        implicitWidth: 100
                    }
                    contentItem: Text {
                        text: parent.text
                        color: root.autoSpin ? "#000000" : Theme.textPrimary
                        font.pixelSize: Theme.fontXs
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Button {
                    text: (root.mode === "3d") ? qsTr("Switch to 2D") : qsTr("Switch to 3D")
                    onClicked: {
                        root.mode = (root.mode === "3d") ? "2d" : "3d";
                        canvas.requestPaint();
                    }
                    background: Rectangle {
                        color: Theme.bgCardElevated
                        border.color: Theme.borderBright
                        radius: Theme.radiusSm
                        implicitHeight: 28
                        implicitWidth: 100
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

            Slider {
                id: angleSlider
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                from: 0
                to: 360
                value: root.angleY
                onMoved: {
                    root.angleY = value;
                    canvas.requestPaint();
                }
            }
        }
    }
}
