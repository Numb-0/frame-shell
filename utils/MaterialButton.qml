import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.VectorImage
import Quickshell
import Quickshell.Widgets


Button {
    required property var iconName
    required property var iconColor
    property var iconSize: 25

    // property var backgroundColor: "transparent"
    // implicitWidth: iconSize + 10
    // implicitHeight: iconSize + 10
    // background: Rectangle {
    //     anchors.fill: parent
    //     color: backgroundColor
        
    //     MaterialSymbol {
    //         anchors.centerIn: parent
    //         width: iconSize
    //         height: iconSize
    //         size: iconSize
    //         icon: iconSource
    //         color: iconColor
    //         fill: 1
    //     }
    // }
    background: MaterialSymbol {
        anchors.centerIn: parent
        size: iconSize
        icon: iconName
        color: iconColor
        fill: 1
    }
}