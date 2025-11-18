import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth

import qs.config
import qs.utils


ColumnLayout {
    id: notif
    property var bt: Bluetooth?.defaultAdapter
    property var connectedDevices: bt?.devices.values.filter((dev) => dev.connected)
    // spacing: 10

    RowLayout {
        // spacing: 10
        MaterialButton {
            onClicked: bt.enabled = !bt?.enabled
            iconName: bt?.enabled ? "bluetooth" : "bluetooth_disabled"
            iconColor: Theme.colors.blue
            implicitHeight: 33
            implicitWidth: 37
            // contentPadding: 0
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
            horizontalAlignment: Text.AlignLeft
            elide: Text.ElideRight
        }

        MaterialButton {
            // visible: bt?.enabled
            // disabled: !bt?.enabled
            onClicked: bt?.startDiscovery()
            iconName: "refresh"
            iconColor: Theme.colors.green
            implicitHeight: 33
            implicitWidth: 37
            // contentPadding: 0
            materialIcon.size: pressed ? 32 : 25
            Behavior on materialIcon.size {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.2
                }
            }
        }
    }

    ListView {
        id: deviceListView
        Layout.fillWidth: true
        Layout.preferredHeight: contentHeight
        model: ScriptModel {
            values: Bluetooth?.devices.values
        }
        // clip: true        
        property var deviceTypes: {
            "audio-headset": "headphones",
            "input-keyboard": "keyboard",
        }
        delegate: RowLayout {
            MaterialSymbol {
                icon: deviceListView.deviceTypes[modelData.icon] ?? "bluetooth"
                color: Theme.colors.blue
                size: 20
            }
            CustomText {
                // anchors.centerIn: parent
                // anchors.fill: parent
                anchors.leftMargin: 10
                text: modelData.deviceName
            }
        }
    }
}

