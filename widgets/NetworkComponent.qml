import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import Quickshell.Networking

import qs.utils.components
import qs.config
import qs.utils.behaviors
import qs.utils.animations


Item {
    id: root
    required property var modelData
    required property int index
    property bool passwordRequired: false
    property string password: ""
    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    property var networkIcons: ({
        none: "wifi_off",
        weak: "wifi_1_bar",
        ok: "wifi_2_bar",
        good: "wifi",
        excellent: "wifi",
        ethernet: "lan"
    })

    function getNetworkIcon(signal, ethernet = false) {
        if (ethernet) return networkIcons.ethernet
        if (signal == 0) return networkIcons.none
        if (signal <= 0.2) return networkIcons.weak
        if (signal <= 0.5) return networkIcons.ok
        if (signal <= 0.75) return networkIcons.good
        return networkIcons.excellent
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: background.color = Theme.colors.base02
        onExited: background.color = Theme.colors.base01
    }

    Rectangle {
        id: background
        anchors.fill: parent
        implicitWidth: col.implicitWidth + Config.spacing * 2
        implicitHeight: col.implicitHeight + Config.spacing * 2
        color: Theme.colors.base01
        ColorBehavior on color { duration: 300 }
        radius: Config.rounding

        Behavior on implicitHeight {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutQuad
            }
        }

        ColumnLayout {
            id: col
            anchors.fill: parent
            anchors.margins: Config.spacing
            spacing: Config.spacing

            RowLayout {
                Layout.fillWidth: true
                spacing: Config.spacing

                MaterialSymbol {
                    Layout.alignment: Qt.AlignVCenter
                    size: 25
                    icon: getNetworkIcon(modelData.signalStrength, modelData.device.type == DeviceType.Wired)
                    color: modelData.connected ? Theme.colors.base0E : Theme.colors.base05
                }

                CustomText {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    text: modelData.name
                    color: modelData.connected ? Theme.colors.base0E : Theme.colors.base05
                }

                RowLayout {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                    spacing: Config.spacing / 2

                    MaterialButton {
                        id: connectButton
                        Layout.alignment: Qt.AlignRight
                        visible: modelData.state == ConnectionState.Disconnected || modelData.state == ConnectionState.Connecting
                        iconName: modelData.known ? "link" : "add_link"
                        iconColor: Theme.colors.base0E
                        onClicked: if (!modelData.Connecting) modelData.connect()

                        Connections {
                            target: modelData
                            function onConnectionFailed(reason) {
                                if (reason === ConnectionFailReason.NoSecrets) {
                                    root.passwordRequired = true
                                }
                            }
                        }

                        Animations.Wiggle {
                            id: wiggleAnimation
                            target: connectButton
                            loops: 1
                            onFinished: {
                                if (modelData.state === ConnectionState.Connecting) {   
                                    wiggleAnimation.start()
                                }
                            }
                        }

                    }

                    MaterialButton {
                        Layout.alignment: Qt.AlignRight
                        visible: modelData.state == ConnectionState.Connected
                        iconName: "link_off"
                        iconColor: Theme.colors.base0E
                        onClicked: modelData.disconnect()
                    }

                    MaterialButton {
                        Layout.alignment: Qt.AlignRight
                        visible: modelData.known
                        iconName: root.passwordRequired ? "cancel" : "delete"
                        iconColor: Theme.colors.base0E
                        onClicked: { 
                            if (root.passwordRequired) {
                                root.passwordRequired = false
                                root.password = ""
                            } else {
                                modelData.forget()
                            }
                        }
                    }
                }
            }

            RowLayout {
                visible: root.passwordRequired
                Layout.fillWidth: true
                spacing: Config.spacing

                Connections {
                    target: modelData
                    function onStateChanged() {
                        if (modelData.state === ConnectionState.Connected) {
                            root.passwordRequired = false
                            root.password = ""
                        } else if (modelData.state === ConnectionState.Connecting) {
                            wiggleAnimation.start()
                        }
                    }
                }

                TextField {
                    readOnly: modelData.state == ConnectionState.Connecting
                    Layout.fillWidth: true
                    implicitHeight: 30
                    placeholderText: "Password"
                    placeholderTextColor: Theme.colors.base05
                    color: Theme.colors.base0E
                    font.pixelSize: 12
                    echoMode: TextInput.Password
                    onTextChanged: root.password = text
                    background: Rectangle {
                        color: Theme.colors.base02
                        radius: Config.rounding / 2
                    }
                }

                MaterialButton {
                    Layout.alignment: Qt.AlignRight
                    iconName: "send"
                    iconColor: Theme.colors.base0E
                    onClicked: modelData.connectWithPsk(root.password)
                }
            }
        }
    }
}


