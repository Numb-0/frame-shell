import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Networking

import qs.config
import qs.utils.components
import qs.utils.animations

Scope {
	id: root
	property bool visible: false
    property var networkWidth: 450
    property var adapter: Networking.devices.values[0] ?? null

    onVisibleChanged: {
        if (!visible && adapter?.type === DeviceType.Wifi) {
            adapter.scannerEnabled = false
        }
    }

    PanelWindow {
        id: window
        screen: Quickshell.screens.find(screen => Hyprland.monitorFor(screen) === Hyprland.focusedMonitor) ?? null
        visible: root.visible
        color: "transparent"
        mask: Region { item: background }
        implicitWidth: root.networkWidth
        focusable: true
        // exclusiveZone: 0
        exclusionMode: ExclusionMode.Normal
        anchors {
            top: true
            bottom: true
            right: true
        }
        margins {
            right: Config.spacing
            top: Config.spacing
        }

        HyprlandFocusGrab {
            windows: [ window ]
            active: root.visible
            onCleared: root.visible = false
        }

        Rectangle {
            id: background
            color: Theme.colors.base01
            radius: Config.rounding
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            implicitHeight: col.implicitHeight + Config.spacing * 2

            ColumnLayout {
                id: col
                anchors.fill: parent
                anchors.margins: Config.spacing
                spacing: Config.spacing

                RowLayout {
                    id: row
                    Layout.fillWidth: true
                    spacing: Config.spacing

                    CustomText {
                        Layout.fillWidth: true
                        text: "Networks"
                        font.pixelSize: 20
                        color: Theme.colors.base0E
                    }

                    MaterialButton {
                        id: refreshButton
                        Layout.alignment: Qt.AlignRight
                        iconName: "refresh"
                        iconColor: Theme.colors.base0E
                        onClicked: {
                            adapter.scannerEnabled = !adapter.scannerEnabled
                            if (adapter.scannerEnabled) {
                                rotationAnimation.start()
                            }
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
                            onFinished: {
                                if (adapter.scannerEnabled) {
                                    rotationAnimation.start()
                                }
                            }
                        }
                    }
                }

                Repeater {
                    model: ScriptModel { values: adapter?.networks?.values ?? [] }
                    delegate: NetworkComponent {
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}