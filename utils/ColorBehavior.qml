import QtQuick

Behavior { 
    property int duration: 1000
    ColorAnimation {
        duration: duration
        easing.type: Easing.InOutQuad
    }
}