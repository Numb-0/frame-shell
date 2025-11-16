import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth

import qs.config
import qs.utils

RowLayout {
    id: notif
    property var bt: Bluetooth?.defaultAdapter
    property var connectedDevices: bt?.devices.values.filter((dev) => dev.connected)

    MaterialButton {
        onClicked: bt.enabled = !bt?.enabled
        iconName: bt?.enabled ? "bluetooth" : "bluetooth_disabled"
        iconColor: Theme.colors.blue
        implicitHeight: 33
        implicitWidth: 37
        materialIcon.size: pressed ? 32 : 25
        Behavior on materialIcon.size {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutBack
                easing.overshoot: 1.2
            }
        }
    }
    
    CustomText {
        text: bt?.enabled ? connectedDevices?.[0]?.deviceName ?? "Nothing Connected" : "Bluetooth Disabled"
        Layout.minimumWidth: 200
        Layout.maximumWidth: 200
        horizontalAlignment: Text.AlignLeft
        elide: Text.ElideRight
    }
}
