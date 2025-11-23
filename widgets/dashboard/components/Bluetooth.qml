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
    spacing: 0
    
    RowLayout {
        spacing: 0

        MaterialButton {
            id: btToggleButton
            onClicked: { 
                bt.enabled = !bt?.enabled
                wiggleAnimation.start()
            }
            iconName: bt?.enabled ? "bluetooth" : "bluetooth_disabled"
            iconColor: bt?.enabled ? Theme.colors.blue : Theme.colors.red
            iconSize: 30

            Animations.WiggleAnimation {
                id: wiggleAnimation
                target: btToggleButton
            }
        }
        CustomText {
            text: bt?.enabled ? connectedDevices?.length > 0 ? connectedDevices.map(dev => dev.name).join(", ") : "Nothing Connected" : "Bluetooth Disabled"
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
        }
        Item { Layout.fillWidth: true }
        MaterialButton {
            id: toggleListButton
            onClicked: {
                listVisible = !listVisible
                rotateArrow.start()
            }
            iconName: "keyboard_arrow_right"
            iconColor: Theme.colors.foreground
            iconSize: 30
            
            RotationAnimation {
                id: rotateArrow
                target: toggleListButton
                from: listVisible ? 0 : 90
                to: listVisible ? 90 : 0
                duration: 300
                easing.type: Easing.OutExpo
            }
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
        Component.onDestruction: {
            deviceListView.model = null
        }
    }
}

