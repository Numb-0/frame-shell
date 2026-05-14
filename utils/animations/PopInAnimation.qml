import QtQuick

ParallelAnimation {
    id: root
    required property var target
    property real targetScale: 1
    property real targetOpacity: 1
    property int duration: 400
    NumberAnimation {
        target: root.target
        property: "scale"
        from: 0.6
        to: root.targetScale
        duration: root.duration
        easing.type: Easing.OutQuad
    }
    NumberAnimation {
        target: root.target
        property: "opacity"
        from: 0
        to: root.targetOpacity
        duration: root.duration
        easing.type: Easing.OutQuad
    }
}
