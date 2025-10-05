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
        // IconButton {
        //     Layout.fillWidth: true
        //     iconColor: Theme.colors.blue
        //     iconSource: bt.enabled ? Quickshell.iconPath("bluetooth-active-symbolic") : Quickshell.iconPath("bluetooth-disabled-symbolic")
        //     onClicked: bt.enabled = !bt.enabled
        // }
        Button {
            onClicked: bt.enabled = !bt.enabled
            background: MaterialSymbol {
                size: 30
                icon: bt.enabled ? "bluetooth" : "bluetooth_disabled"
                color: Theme.colors.blue
            }
        }
        CustomText {
            text: connectedDevices[0]?.deviceName ?? "No connected devices"
        }
    }
}
