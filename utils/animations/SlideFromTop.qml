import QtQuick

ParallelAnimation {
    id: root
    required property var target
    property int duration: 300
    NumberAnimation {
        target: root.target
        property: "y"
        from: root.target.y - 20
        to: root.target.y
        duration: root.duration
        easing.type: Easing.OutCubic
    }
    NumberAnimation {
        target: root.target
        property: "opacity"
        from: 0
        to: 1
        duration: root.duration
        easing.type: Easing.OutCubic
    }
}
