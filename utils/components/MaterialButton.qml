import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.VectorImage
import Quickshell
import Quickshell.Widgets

import qs.config


Button {
    id: btn
    required property var iconName
    required property var iconColor
    property var iconSize: 25
    property var iconPadding: 0
     
    // expose the internal components so parent code can reference/animate it
    property alias iconSymbol: iconSymbol
    property alias iconBackground: iconBackground

    background: Item {
        implicitHeight: iconSymbol.implicitHeight + iconPadding * 2
        implicitWidth: iconSymbol.implicitWidth + iconPadding * 4

        Rectangle {
            id: iconBackground
            anchors.fill: parent
            color: "transparent"
            radius: Config.rounding
            Behavior on opacity { NumberAnimation { duration: 200 } }
        }

        MaterialSymbol {
            id: iconSymbol
            anchors.centerIn: parent
            size: iconSize
            icon: iconName
            color: iconColor
            fill: 1
        }
    }
}