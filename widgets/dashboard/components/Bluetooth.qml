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
    property var bt: Bluetooth?.defaultAdapter
    property var connectedDevices: bt?.devices.values.filter((dev) => dev.connected)
    color: Theme.colors.background
    RowLayout {
        MaterialButton {
            onClicked: bt.enabled = !bt?.enabled
            iconName: bt?.enabled ? "bluetooth" : "bluetooth_disabled"
            iconColor: Theme.colors.blue
            backgroundColor: Theme.colors.backgroundHighlight
        }
        CustomText {
            text: bt?.enabled ? connectedDevices[0]?.deviceName ?? "No connected devices" : "Bluetooth Disabled"
        }
    }
}
