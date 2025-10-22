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
    required property var backgroundColor
    // expose the internal symbol so parent code can reference/animate it
    property alias materialIcon: symbol
    property var iconSize: 25
    property var contentPadding: 4

    background: Item {
        implicitHeight: symbol.implicitHeight + contentPadding * 2
        implicitWidth: symbol.implicitWidth + contentPadding * 4

        Rectangle {
            id: bgrect
            anchors.fill: parent
            color: backgroundColor
            radius: Config.rounding
            Behavior on opacity { NumberAnimation { duration: 200 } }
            opacity: btn.focus ? 1 : 0
        }

        MaterialSymbol {
            id: symbol
            anchors.centerIn: parent
            size: iconSize
            icon: iconName
            color: iconColor
            fill: 1
            // opacity: 1
        }
    }
}