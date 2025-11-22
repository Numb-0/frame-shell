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
    property bool listVisible: false
        
    RowLayout {
        MaterialButton {
            onClicked: bt.enabled = !bt?.enabled
            iconName: bt?.enabled ? "bluetooth" : "bluetooth_disabled"
            iconColor: Theme.colors.blue
            
        }
        Item { Layout.fillWidth: true }
        CustomText {
            text: bt?.enabled ? connectedDevices?.length > 0 ? connectedDevices.map(dev => dev.deviceName).join(", ") : "Nothing Connected" : "Bluetooth Disabled"
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
        }
        Item { Layout.fillWidth: true }
        MaterialButton {
            onClicked: listVisible = !listVisible
            iconName: "chevron_right"
            iconColor: Theme.colors.foreground
            
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
    
    
    ListView {
        id: deviceListView
        implicitHeight: contentHeight
        Layout.fillWidth: true
        clip: true        
        model: ScriptModel {
            values: Bluetooth?.devices.values
        }
        states: [
            State {
                name: "hidden"
                when: !listVisible
                PropertyChanges { target: deviceListView; implicitHeight: 0 }
            },
            State {
                name: "visible"
                when: listVisible
                PropertyChanges { target: deviceListView; implicitHeight: contentHeight }
            }
        ]
        transitions: [
            Transition {
                from: "hidden"; to: "visible"
                NumberAnimation {
                    properties: "implicitHeight"
                    duration: 300
                    easing.type: Easing.OutExpo
                }
            },  
            Transition {
                from: "visible"; to: "hidden"
                NumberAnimation {
                    properties: "implicitHeight"
                    duration: 300
                    easing.type: Easing.OutExpo
                }
            }
        ]
        property var deviceTypes: {
            "audio-headset": "headphones",
            "input-keyboard": "keyboard",
            "default": "bluetooth"
        }
        delegate: RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            MaterialButton {
                
                iconName: deviceListView.deviceTypes[modelData.icon] ?? "devices"
                iconColor: Theme.colors.blue
            }
            Item { Layout.fillWidth: true }
            CustomText {
                text: modelData.deviceName
            }
            Item { Layout.fillWidth: true }
            MaterialButton {
                
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

