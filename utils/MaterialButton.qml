import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.VectorImage
import Quickshell
import Quickshell.Widgets

import qs.config


Button {
    required property var iconName
    required property var iconColor
    property var iconSize: 25
    
    // Pulsing ring animation for focus
    Rectangle {
        id: rect
        anchors.centerIn: parent
        width: parent.width + 28
        height: parent.height + 20
        // radius: width / 2
        color: "transparent"
        // color: parent.focus ? Theme.colors.foreground : "transparent"
        border.color: Theme.colors.backgroundHighlight
        border.width: 4
        opacity: parent.focus ? 1 : 0
        
        SequentialAnimation on opacity {
            running: parent.focus
            loops: Animation.Infinite
            NumberAnimation { from: 0.3; to: 1; duration: 800 }
            NumberAnimation { from: 1; to: 0.3; duration: 800 }
        }
        Component.onCompleted: {
            console.log(rect.width, rect.height)
        }
    }

    background: MaterialSymbol {
        anchors.centerIn: parent
        size: iconSize
        icon: iconName
        color: iconColor
        fill: 1
    }
}