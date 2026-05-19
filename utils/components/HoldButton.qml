import QtQuick
import QtQuick.Shapes

MaterialButton {
    id: root
    property int holdDuration: 800
    property int strokeWidth: 2
    property color progressColor: iconColor
    signal triggered()

    property real _progress: 0
    property bool _completed: false

    Shape {
        parent: root.iconBackground
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        opacity: root._progress > 0 ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 120 } }

        ShapePath {
            strokeWidth: root.strokeWidth
            strokeColor: root.progressColor
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: root.iconBackground.width / 2
                centerY: root.iconBackground.height / 2
                radiusX: Math.min(root.iconBackground.width, root.iconBackground.height) / 2 - root.strokeWidth
                radiusY: radiusX
                startAngle: -90
                sweepAngle: root._progress * 360
            }
        }
    }

    NumberAnimation {
        id: fillAnim
        target: root
        property: "_progress"
        from: root._progress
        to: 1
        duration: root.holdDuration * (1 - root._progress)
        easing.type: Easing.Linear
        onFinished: {
            root._completed = true
            root.triggered()
        }
    }

    NumberAnimation {
        id: resetAnim
        target: root
        property: "_progress"
        to: 0
        duration: 200
        easing.type: Easing.OutQuad
    }

    Connections {
        target: root
        function onPressed() {
            resetAnim.stop()
            root._completed = false
            fillAnim.start()
        }
        function onReleased() {
            fillAnim.stop()
            if (root._completed) {
                root._progress = 0
            } else {
                resetAnim.start()
            }
        }
        function onCanceled() {
            fillAnim.stop()
            resetAnim.start()
        }
    }
}
