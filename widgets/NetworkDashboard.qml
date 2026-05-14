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
    property var adapter: Networking.devices.values.find(device => device.type === DeviceType.Wifi) ?? null

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
            implicitHeight: row.implicitHeight + networkList.contentHeight + Config.spacing * 2

            Behavior on implicitHeight {
                NumberAnimation {
                    duration: 400
                    // easing.overshoot: 1
                    easing.type: Easing.OutQuad
                }
            }

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

                ListView {
                    id: networkList
                    Layout.fillWidth: true
                    implicitHeight: window.height
                    interactive: false
                    spacing: Config.spacing
                    model: ScriptModel { values: adapter?.networks?.values ?? [] }
                    delegate: NetworkComponent {
                        width: ListView.view.width
                    }
                    add: Transition {
                        id: addTransition
                        ParallelAnimation {
                            NumberAnimation { property: "scale";   from:  1 / ( 1 + addTransition.ViewTransition.index * 0.5 );  to: 1; duration: 400; easing.type: Easing.OutQuad }
                            NumberAnimation { property: "opacity"; from: 0;   to: 1; duration: 400; easing.type: Easing.OutQuad }
                        }
                    }
                    remove: Transition {
                        id: removeTransition
                        ParallelAnimation {
                            NumberAnimation { property: "scale";   from: 1;   to: 1 / (1 + removeTransition.ViewTransition.index * 0.5); duration: 400; easing.type: Easing.InQuad }
                            NumberAnimation { property: "opacity"; from: 1;   to: 0; duration: 400; easing.type: Easing.InQuad }
                        }
                    }
                    displaced: Transition {
                        NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.InOutQuad }
                    }
                }
            }
        }
    }
}