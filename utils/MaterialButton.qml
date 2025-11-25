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
    property var backgroundColor: "transparent" 
    // expose the internal symbol so parent code can reference/animate it
    property alias materialIcon: symbol
    property alias buttonBackground: bgrect
    property var iconSize: 25
    property var iconPadding: 5

    background: Item {
        implicitHeight: symbol.implicitHeight + iconPadding * 2
        implicitWidth: symbol.implicitWidth + iconPadding * 4
        Rectangle {
            id: bgrect
            anchors.fill: parent
            color: backgroundColor
            radius: Config.rounding
            Behavior on opacity { NumberAnimation { duration: 200 } }
        }

        MaterialSymbol {
            id: symbol
            anchors.centerIn: parent
            size: iconSize
            icon: iconName
            color: iconColor
            fill: 1
        }
    }
}