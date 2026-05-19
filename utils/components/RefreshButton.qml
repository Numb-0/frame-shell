import QtQuick

MaterialButton {
    id: root
    property int spinDuration: 3000
    signal finished()

    iconName: "refresh"
    iconSize: 30
    iconPadding: 5

    Connections {
        target: root
        function onClicked() {
            rotationAnim.loops = RotationAnimation.Infinite
            rotationAnim.start()
            finishTimer.start()
        }
    }

    RotationAnimation {
        id: rotationAnim
        target: root
        from: 0
        to: 360
        duration: 1000
        easing.type: Easing.InOutBack
        easing.overshoot: 1.2
        loops: 1
    }

    Timer {
        id: finishTimer
        interval: root.spinDuration
        repeat: false
        onTriggered: {
            rotationAnim.loops = 1
            rotationAnim.stop()
            root.rotation = 0
            root.finished()
        }
    }
}
