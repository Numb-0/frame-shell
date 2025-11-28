pragma Singleton

import QtQuick
import Quickshell

Singleton {
    // Wiggle animation - rotates back and forth
    component WiggleAnimation: SequentialAnimation {
        id: root
        required property var target
        NumberAnimation {
            target: root.target
            property: "rotation"
            from: 0; to: -10
            duration: 50
            easing.type: Easing.OutQuad
        }
        NumberAnimation {
            target: root.target
            property: "rotation"
            to: 10
            duration: 100
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: root.target
            property: "rotation"
            to: -10
            duration: 100
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: root.target
            property: "rotation"
            to: 10
            duration: 100
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: root.target
            property: "rotation"
            to: 0
            duration: 50
            easing.type: Easing.InQuad
        }
    }

    // Fade slide in from left animation
    component Fade: ParallelAnimation {
        id: root
        required property var target
        property int duration: 300
        
        NumberAnimation {
            target: root.target
            property: "opacity"
            from: 0
            to: 1
            duration: root.duration
            easing.type: Easing.OutCubic
        }
    }    

    component SlideFromTop: ParallelAnimation {
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
}
