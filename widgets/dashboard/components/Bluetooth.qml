import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth

import qs.config
import qs.utils

Rectangle {
    id: notif
    property int padding: 10
    property var bt: Bluetooth.defaultAdapter
    property var connectedDevices: bt?.devices.values.filter((dev) => dev.connected)
    color: Theme.colors.background
    // implicitWidth: 200 + padding * 2
    // implicitHeight: 100 + padding * s2
    RowLayout {
        id: row
        IconButton {
            Layout.fillWidth: true
            iconColor: Theme.colors.blue
            iconSource: bt.enabled ? Quickshell.iconPath("bluetooth-active-symbolic") : Quickshell.iconPath("bluetooth-disabled-symbolic")
            onClicked: bt.enabled = !bt.enabled
        }
        CustomText {
            // Layout.alignment: Qt.AlignRight
            text: connectedDevices[0]?.deviceName ?? "No connected devices"
        }
    }
}