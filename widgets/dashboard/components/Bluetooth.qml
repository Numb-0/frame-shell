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
    id: root
    property var bt: Bluetooth?.defaultAdapter
    property var connectedDevices: bt?.devices.values.filter((dev) => dev.connected)
    property bool listVisible: false
    spacing: 0
    
    RowLayout {
        spacing: 0
        MaterialButton {
            id: btToggleButton
            iconName: bt?.enabled ? "bluetooth" : "bluetooth_disabled"
            iconColor: bt?.enabled ? Theme.colors.base0D : Theme.colors.base08
            iconSize: 30
            iconPadding: 5
            onClicked: { 
                bt.enabled = !bt.enabled
                listVisible = bt.enabled ? listVisible : false
                wiggleAnimation.start()
            }

            Animations.WiggleAnimation {
                id: wiggleAnimation
                target: btToggleButton
            }
        }
        CustomText {
            text: bt?.enabled ? connectedDevices?.length > 0 ? connectedDevices.map(dev => dev.name).join(", ") : "Nothing Connected" : "Bluetooth Disabled"
            elide: Text.ElideRight
        }
        Item { Layout.fillWidth: true }
        MaterialButton {
            id: toggleListButton
            property bool rotated: false
            iconName: "keyboard_arrow_right"
            iconColor: Theme.colors.base05
            iconSize: 30
            iconPadding: 5

            onClicked: {
                if (!bt.enabled) {
                    bt.enabled = true
                }
                listVisible = !listVisible
            }

            Connections {
                target: root
                function onListVisibleChanged() {
                    rotateArrowDown.start()
                }
            }
            
            RotationAnimation {
                id: rotateArrowDown
                target: toggleListButton
                from: listVisible ? 0 : 90
                to: listVisible ? 90 : 0
                duration: 300
                easing.type: Easing.OutExpo
            }
        }
        MaterialButton {
            id: refreshButton
            enabled: (bt?.enabled && !bt?.discovering) ?? false
            iconName: "refresh"
            iconColor: bt?.enabled ? Theme.colors.base0D : Theme.colors.base08
            iconSize: 30
            iconPadding: 5
            onClicked: {
                bt.discovering = true;
                startRotation()
                discoveryTimer.start()
            }

            function startRotation() {
                rotationAnimation.loops = RotationAnimation.Infinite
                rotationAnimation.start()
            }
            
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
                interval: 15000
                repeat: false
                onTriggered: {
                    bt.discovering = false;
                    rotationAnimation.loops = 1
                    rotationAnimation.stop()
                    refreshButton.rotation = 0
                }
            }
        }
    }
    Dialog {
        id: deleteDeviceDialog
        anchors.centerIn: parent
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel
        background: Rectangle {
            color: Theme.colors.base00
            radius: Config.rounding
        }
        footer: Rectangle {
            color: Theme.colors.base00
            radius: Config.rounding
            Text {
                text: "This action cannot be undone."
                color: Theme.colors.base08
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
            }
        }

        header: Rectangle {
            color: Theme.colors.base00
            radius: Config.rounding
        }
    }
    Item {
        Layout.fillWidth: true
        implicitHeight: deviceListView.implicitHeight
        
        ListView {
            id: deviceListView
            anchors.fill: parent
            snapMode: ListView.SnapToItem
            property int showCount: count < 3 ? count : 3
            clip: true
            model: ScriptModel {
                values: Bluetooth?.devices.values.filter((dev) => dev.deviceName !== "")
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
                    PropertyChanges { target: deviceListView; implicitHeight: contentHeight * showCount / count }
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
                    iconColor: Theme.colors.base0D
                    iconPadding: 5
                    iconSize: 30
                }
                CustomText {
                    text: modelData.deviceName
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
                Item { Layout.fillWidth: true }
                MaterialButton {
                    visible: !modelData.paired
                    iconName: "add_link"
                    iconColor: Theme.colors.base0A
                    iconSize: 30
                    iconPadding: 5
                    onClicked: {
                        modelData.pair()
                    }
                }
                MaterialButton {
                    visible: modelData.paired
                    iconName: "remove"
                    iconColor: Theme.colors.base08
                    iconSize: 30
                    iconPadding: 5
                    onClicked: {
                        deleteDeviceDialog.title = "Are you sure you want to remove " + modelData.deviceName + "?"
                        deleteDeviceDialog.open()
                        // modelData.forget()
                    }
                }
                MaterialButton {
                    property var connectionIcons: {
                        "Connected": "link_off",
                        "Disconnected": "link",
                        "Connecting": "sync_alt",
                        "Disconnecting": "sync_alt"
                    }
                    visible: modelData.paired
                    iconName: connectionIcons[BluetoothDeviceState.toString(modelData.state)]
                    iconColor: modelData.connected ? Theme.colors.base08 : Theme.colors.base0D
                    iconSize: 30
                    iconPadding: 5
                    onClicked: {
                        if (modelData.connected) {
                            modelData.disconnect()
                        } else {
                            modelData.connect()
                        }
                    }
                }
            }
            remove: Transition {
                ParallelAnimation {
                    NumberAnimation { properties: "x"; duration: 600; from: 0; to: 300; easing.type: Easing.InOutQuad }
                    NumberAnimation { properties: "opacity"; duration: 400; from: 1; to: 0; easing.type: Easing.OutExpo }
                }
            }
            add: Transition {
                ParallelAnimation {
                    NumberAnimation { properties: "x"; duration: 600; from: 260; to: 0; easing.type: Easing.OutExpo }
                    NumberAnimation { properties: "opacity"; duration: 400; from: 0; to: 1; easing.type: Easing.OutExpo }
                }
            }
            displaced: Transition {
                NumberAnimation { properties: "y"; duration: 300; easing.type: Easing.OutExpo }
            }
            Component.onDestruction: {
                deviceListView.model = null
            }
        }
    }
}

