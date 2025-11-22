import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland

import qs.config
import qs.utils
import qs.widgets.dashboard.components

Scope {
	id: root
	property bool visible: false

    GlobalShortcut {
		name: "dashboard"
		onPressed: root.visible = !root.visible
	}

    PanelWindow {
        id: window
        color: "transparent"
        // Wayland/Hyprland
        screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? null
        mask: Region { item: shp }
        focusable: true
        implicitWidth: shp.implicitWidth
        anchors.top: true
        anchors.bottom: true
        exclusiveZone: -1
        // Distance from the bar since we using exclusiveZone = -1
        margins.top: 40

        Shape {
            id: shp
            property real margin: 20
            property real roundingMax: 20
            property real rounding: 0
            anchors.top: window.top
            width: col.implicitWidth + margin * 2
            states: [
                State {
                    name: "hidden"
                    when: !root.visible
                    PropertyChanges { target: shp; rounding: 0; height: 0 }
                    PropertyChanges { target: col; opacity: 0 }
                },
                State {
                    name: "visible"
                    when: root.visible
                    PropertyChanges { target: shp; rounding: roundingMax; height: col.implicitHeight  }
                    PropertyChanges { target: col; opacity: 1 }
                }
            ]

            transitions: [
                Transition {
                    from: "hidden"; to: "visible"
                    ParallelAnimation {
                        NumberAnimation {
                            properties: "height"
                            duration: 500
                            easing.type: Easing.OutBack
                        }
                        NumberAnimation {
                            properties: "rounding"
                            duration: 500
                            easing.type: Easing.OutCirc
                        }
                        NumberAnimation {
                            property: "opacity"
                            duration: 300
                            easing.type: Easing.InOutQuad
                        }
                    }
                },

                Transition {
                    from: "visible"; to: "hidden"
                    ParallelAnimation {
                        ParallelAnimation {
                            NumberAnimation {
                                properties: "height"
                                duration: 500
                                easing.type: Easing.InBack
                            }
                            NumberAnimation {
                                properties: "rounding"
                                duration: 500
                                easing.type: Easing.InCirc
                            }
                             NumberAnimation {
                                property: "opacity"
                                duration: 300
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }
            ]
            
            ShapePath {
                fillColor: Theme.colors.backgroundAlt
                strokeWidth: 0
                startX: 0; startY: 0
                PathLine { x: shp.width; y: 0}
                // Top-right corner
                PathQuad { x: shp.width - shp.rounding; y: shp.rounding; controlX: shp.width - shp.rounding; controlY: 0 }
                PathLine { x: shp.width - shp.rounding; y: shp.height - shp.rounding }
                // Bottom-right corner
                PathQuad { x: shp.width - shp.rounding * 2; y: shp.height; controlX: shp.width - shp.rounding; controlY: shp.height }
                PathLine { x: shp.rounding * 2; y: shp.height }
                // Bottom-left corner
                PathQuad { x: shp.rounding; y: shp.height - shp.rounding; controlX: shp.rounding; controlY: shp.height }
                PathLine { x: shp.rounding; y: shp.rounding }
                // Top-left corner
                PathQuad { x: 0; y: 0; controlX: shp.rounding; controlY: 0 }
            }
        }

        ColumnLayout {
            id: col
            anchors.centerIn: shp
            property int minimumWidth: 300
            spacing: 0
            Bluetooth { Layout.minimumWidth: col.minimumWidth }
            PowerProfiles { Layout.minimumWidth: col.minimumWidth }
        }
    }
}
