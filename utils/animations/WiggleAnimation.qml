import QtQuick

SequentialAnimation {
    id: root
    required property var target
    property var duration: 100
    property var inclination: 10
    NumberAnimation {
        target: root.target
        property: "rotation"
        from: 0; to: -root.inclination
        duration: root.duration 
        easing.type: Easing.OutQuad
    }
    NumberAnimation {
        target: root.target
        property: "rotation"
        to: root.inclination
        duration: root.duration 
        easing.type: Easing.InOutQuad
    }
    NumberAnimation {
        target: root.target
        property: "rotation"
        to: -root.inclination
        duration: root.duration 
        easing.type: Easing.InOutQuad
    }
    NumberAnimation {
        target: root.target
        property: "rotation"
        to: root.inclination
        duration: root.duration
        easing.type: Easing.InOutQuad
    }
    NumberAnimation {
        target: root.target
        property: "rotation"
        to: 0
        duration: root.duration
        easing.type: Easing.InQuad
    }
}
