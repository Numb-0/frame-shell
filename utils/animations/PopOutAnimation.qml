import QtQuick

ParallelAnimation {
    id: root
    required property var target
    property real targetScale: 0
    property real targetOpacity: 0
    property real duration: 400
    NumberAnimation {
        target: root.target
        property: "scale"
        to: targetScale
        duration: root.duration
        easing.type: Easing.OutQuad
    }
    NumberAnimation {
        target: root.target
        property: "opacity"
        to: targetOpacity
        duration: root.duration
        easing.type: Easing.OutQuad
    }
}