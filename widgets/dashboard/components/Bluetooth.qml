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
    property var bt: Bluetooth?.defaultAdapter
    property var connectedDevices: bt?.devices.values.filter((dev) => dev.connected)

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 48
        
        RowLayout {
            anchors.fill: parent
            MaterialButton {
                onClicked: bt.enabled = !bt?.enabled
                iconName: bt?.enabled ? "bluetooth" : "bluetooth_disabled"
                iconColor: Theme.colors.blue
                contentPadding: 0
            }
            Item { Layout.fillWidth: true }
            MaterialButton {
                onClicked: console.log("Open Bluetooth Settings")
                iconName: "chevron_right"
                iconColor: Theme.colors.foreground
                contentPadding: 0
            }
            MaterialButton {
                id: refreshButton
                onClicked: {
                    bt?.startDiscovery()
                    rotationAnimation.loops = RotationAnimation.Infinite
                    rotationAnimation.start()
                    discoveryTimer.start()
                }
                iconName: "refresh"
                iconColor: Theme.colors.green
                contentPadding: 0
                
                RotationAnimation {
                    id: rotationAnimation
                    target: refreshButton
                    from: 0
                    to: 360
                    duration: 1000
                    easing.type: Easing.InOutBack
                    easing.overshoot: 1.2
                    loops: 1
                }
                
                Timer {
                    id: discoveryTimer
                    interval: 10000
                    repeat: false
                    onTriggered: {
                        bt?.stopDiscovery()
                        rotationAnimation.loops = 1
                        rotationAnimation.stop()
                        refreshButton.rotation = 0
                    }
                }
            }
        }
        
        CustomText {
            anchors.centerIn: parent
            text: bt?.enabled ? connectedDevices?.length > 0 ? connectedDevices.map(dev => dev.deviceName).join(", ") : "Nothing Connected" : "Bluetooth Disabled"
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
        }
    }
    
    
    ListView {
        id: deviceListView
        Layout.preferredHeight: contentHeight
        Layout.fillWidth: true
        clip: true        
        model: ScriptModel {
            values: Bluetooth?.devices.values
        }
        property var deviceTypes: {
            "audio-headset": "headphones",
            "input-keyboard": "keyboard",
            "default": "bluetooth"
        }
        delegate: RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            MaterialButton {
                contentPadding: 0
                iconName: deviceListView.deviceTypes[modelData.icon] ?? "devices"
                iconColor: Theme.colors.blue
            }
            Item { Layout.fillWidth: true }
            CustomText {
                text: modelData.deviceName
            }
            Item { Layout.fillWidth: true }
            MaterialButton {
                contentPadding: 0
                iconName: modelData.connected ? "link_off" : "link"
                iconColor: modelData.connected ? Theme.colors.red : Theme.colors.green
                onClicked: {
                    if (modelData.connected) {
                        modelData.disconnect()
                    } else {
                        modelData.connect()
                    }
                }
            }   
        }
    }
}

