import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Io

import qs.config
import qs.utils
import qs.services


ColumnLayout {
    id: root
    property var network: NetworkService
    property bool listVisible: false
    spacing: 0
    
    RowLayout {
        spacing: 0
        MaterialButton {
            id: wifiToggleButton
            iconName: network.wifiState ? "wifi" : "wifi_off"
            iconColor: network.wifiState ? Theme.colors.purple : Theme.colors.red
            iconSize: 30
            iconPadding: 5
            onClicked: { 
                network.toggleWifi()
                wiggleAnimation.start()
            }

            Animations.WiggleAnimation {
                id: wiggleAnimation
                target: wifiToggleButton
            }
        }
        CustomText {
            text: network.wifiState ? network.connectedNetwork ? network.connectedNetwork.ssid : "Not Connected" : "WiFi Disabled"
            elide: Text.ElideRight
        }
        Item { Layout.fillWidth: true }
        MaterialButton {
            id: toggleListButton
            property bool rotated: false
            iconName: "keyboard_arrow_right"
            iconColor: Theme.colors.foreground
            iconSize: 30
            iconPadding: 5

            onClicked: {
                if (network.wifiState && network.connections.length > 0) {
                    listVisible = !listVisible
                }
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
            enabled: network.wifiState
            iconName: "refresh"
            iconColor: network.wifiState ? Theme.colors.purple : Theme.colors.red
            iconSize: 30
            iconPadding: 5
            onClicked: {
                // network.updateNetworkStatus()
                startRotation()
                refreshTimer.start()
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
                id: refreshTimer
                interval: 3000
                repeat: false
                onTriggered: {
                    rotationAnimation.loops = 1
                    rotationAnimation.stop()
                    refreshButton.rotation = 0
                }
            }
        }
    }
    
    Item {
        Layout.fillWidth: true
        implicitHeight: networkListView.implicitHeight
        
        ListView {
            id: networkListView
            anchors.fill: parent
            snapMode: ListView.SnapToItem
            property int showCount: count < 5 ? count : 5
            clip: true
            model: ScriptModel {
                values: network.connections
            }
            states: [
                State {
                    name: "hidden"
                    when: !listVisible
                    PropertyChanges { target: networkListView; implicitHeight: 0 }
                },
                State {
                    name: "visible"
                    when: listVisible
                    PropertyChanges { target: networkListView; implicitHeight: contentHeight * showCount / count }
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
            
            function getWifiIcon(signal) {
                if (signal >= 80) return "wifi"
                if (signal >= 60) return "wifi_2_bar"
                if (signal >= 40) return "wifi_1_bar"
                return "wifi_1_bar"
            }
            
            function getSecurityIcon(security) {
                if (security.includes("WPA") || security.includes("WEP")) return "lock"
                return "lock_open"
            }
            
            delegate: RowLayout {
                anchors.left: parent?.left
                anchors.right: parent?.right
                property bool isConnected: modelData.isActive
                
                MaterialButton {
                    iconName: networkListView.getWifiIcon(modelData.signal)
                    iconColor: isConnected ? Theme.colors.purple : Theme.colors.foreground
                    iconPadding: 5
                    iconSize: 30
                }
                CustomText {
                    text: modelData.ssid
                    color: isConnected ? Theme.colors.purple : Theme.colors.foreground
                    font.weight: isConnected ? Font.Bold : Font.Normal
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
                CustomText {
                    text: modelData.signal + "%"
                    color: Theme.colors.foreground
                }
                MaterialButton {
                    iconName: networkListView.getSecurityIcon(modelData.security)
                    iconColor: modelData.saved ? Theme.colors.green : Theme.colors.yellow
                    iconSize: 20
                    iconPadding: 5
                    visible: modelData.security !== ""
                }
                MaterialButton {
                    visible: !isConnected
                    iconName: "link"
                    iconColor: Theme.colors.purple
                    iconSize: 30
                    iconPadding: 5
                    onClicked: network.connect(modelData.ssid)
                }
                MaterialButton {
                    visible: isConnected
                    iconName: "link_off"
                    iconColor: Theme.colors.red
                    iconSize: 30
                    iconPadding: 5
                    onClicked: {
                        network.disconnect()
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
                networkListView.model = null
            }
        }
    }
}
