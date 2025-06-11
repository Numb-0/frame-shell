import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.VectorImage
import Quickshell
import Quickshell.Widgets

// Image {
//     required property var iconSource
//     property var iconSize: 13
//     required property var iconColor

//     sourceSize.width: iconSize
//     sourceSize.height: iconSize
//     mipmap: true
//     source: iconSource
//     layer.enabled: true
//     layer.effect: MultiEffect {
//         colorization: 1
//         colorizationColor: iconColor
//         // opacity: 1
//         // brightness: -1       // Makes grays brighter
//         // contrast: 1        // Ensures full color intensity
//         // saturation: 0.3
//         // shadowEnabled: false
//     }
// }

Button {
    required property var iconSource
    property var iconSize: 13
    required property var iconColor
    property var backgroundColor: "transparent"

    background: Rectangle {
        color: parent.backgroundColor 
        ColorBehavior on color { duration: 200 }
    }
    icon.source: iconSource
    icon.width: iconSize
    icon.height: iconSize
    icon.color: iconColor
    ColorBehavior on icon.color {}
}
