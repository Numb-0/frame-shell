import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth

import qs.config
import qs.utils.animations
import qs.utils.components


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
                bt.enabled = !bt?.enabled
                listVisible = bt.enabled ? listVisible : false
                wiggleAnimation.start()
            }

            Animations.Wiggle {
                id: wiggleAnimation
                target: btToggleButton
            }
        }
        CustomText {
            text: bt?.enabled ? connectedDevices?.length > 0 ? connectedDevices.map(dev => dev.name).join(", ") : "Nothing Connected" : "Bluetooth Disabled"
            elide: Text.ElideRight

        }
        Item { Layout.fillWidth: true }
        ExpandArrowButton {
            expanded: root.listVisible
            onClicked: {
                if (!bt?.enabled) {
                    bt.enabled = true
                }
                root.listVisible = !root.listVisible
            }
        }
        RefreshButton {
            enabled: (bt?.enabled && !bt?.discovering) ?? false
            iconColor: bt?.enabled ? Theme.colors.base0D : Theme.colors.base08
            spinDuration: 15000
            onClicked: bt.discovering = true
            onFinished: bt.discovering = false
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
                    when: !root.listVisible
                    PropertyChanges { target: deviceListView; implicitHeight: 0 }
                },
                State {
                    name: "visible"
                    when: root.listVisible
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
                spacing: 0
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
                    onClicked: pairWiggle.start()

                    Animations.Wiggle {
                        id: pairWiggle
                        target: parent
                        onFinished: modelData.pair()
                    }
                }
                HoldButton {
                    visible: modelData.paired
                    iconName: "remove"
                    iconColor: Theme.colors.base08
                    iconSize: 30
                    iconPadding: 1
                    onTriggered: modelData.forget()
                }
                MaterialButton {
                    id: connectionButton
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
                    onClicked: connectionWiggle.start()

                    Animations.Wiggle {
                        id: connectionWiggle
                        target: connectionButton
                        onFinished: {
                            if (modelData.connected) {
                                modelData.disconnect()
                            } else {
                                modelData.connect()
                            }
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

