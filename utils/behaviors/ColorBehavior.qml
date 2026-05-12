import QtQuick

Behavior {
    id: root 
    property int duration: 1000
    ColorAnimation {
        duration: root.duration
        easing.type: Easing.OutQuad
    }
}