import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.VectorImage
import Quickshell
import Quickshell.Widgets


Button {
    required property var iconSource
    property var iconColor
    property var iconSize: 20
    property var backgroundColor: "transparent"
    background: Rectangle { color: backgroundColor }

    implicitHeight: iconSize
    implicitWidth: iconSize

    IconImage {
        id: icon
        anchors.fill: parent
        source: iconSource
        smooth: true
        asynchronous: true
        layer.enabled: iconColor ? true : false
        layer.effect: MultiEffect {
            colorization: 1
            colorizationColor: iconColor
        }
    }
}
