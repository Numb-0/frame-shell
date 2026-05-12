import QtQuick

ParallelAnimation {
    id: root
    required property var target
    property real targetScale: 1
    property real targetOpacity: 1
    NumberAnimation {
        target: root.target
        property: "scale"
        from: 0.6
        to: targetScale
        duration: 400
        easing.type: Easing.OutQuad
    }
    NumberAnimation {
        target: root.target
        property: "opacity"
        from: 0
        to: targetOpacity
        duration: 400
        easing.type: Easing.OutQuad
    }
}
