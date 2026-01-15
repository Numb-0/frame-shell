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
		onPressed: {
            if (window.screenChanging) return
            root.visible = !root.visible
        }
	}

    PanelWindow {
        id: window
        property var currentMonitor: Quickshell.screens.find(s => s.name == Hyprland.focusedMonitor?.name)
        property bool animationRunning: showTransition.running || hideTransition.running
        property bool screenChanging: screenChangeAnimationDelay.running || visibilityDelay.running

        color: "transparent"
        mask: Region { item: shp }
        implicitWidth: shp.implicitWidth
        anchors {
            top: true
            bottom: true
        }
        exclusiveZone: -1
        margins.top: 40

        onCurrentMonitorChanged: {
            if (!root.visible && !animationRunning) {
                window.screen = window.currentMonitor
            } else {
                root.visible = false
                screenChangeAnimationDelay.restart()
            }
        }

        Timer {
            id: screenChangeAnimationDelay
            interval: 550 // +50 ms so we are sure the animation finished
            onTriggered: {
                window.screen = window.currentMonitor
                // Show the dashboard again after changing monitor
                // Wait for the panelwindow to reposition itself
                visibilityDelay.restart()
            }
        }

        Timer {
            id: visibilityDelay
            interval: 300
            onTriggered: {
                root.visible = true
            }
        }
        
        Shape {
            id: shp
            property real padding: Config.rounding * 2
            property real rounding: 0
            anchors.top: window.top
            width: col.implicitWidth + Config.rounding * 4
            states: [
                State {
                    name: "hidden"
                    when: !root.visible
                    PropertyChanges { target: shp; rounding: 0; height: 0 }
                },
                State {
                    name: "visible"
                    when: root.visible
                    PropertyChanges { target: shp; rounding: Config.rounding * 2; height: col.implicitHeight  }
                }
            ]

            transitions: [
                Transition {
                    id: showTransition
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
                    }
                },

                Transition {
                    id: hideTransition
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
            property int preferredWidth: 500
            anchors.bottom: shp.bottom
            anchors.left: shp.left
            anchors.right: shp.right
            anchors.leftMargin: shp.padding
            anchors.rightMargin: shp.padding
            spacing: 0
            Keys.onEscapePressed: root.visible = false
            Wifi { Layout.preferredWidth: col.preferredWidth }
            Bluetooth { Layout.preferredWidth: col.preferredWidth }
            PowerProfiles { Layout.preferredWidth: col.preferredWidth }
            Brightness { Layout.preferredWidth: col.preferredWidth }
            Volume { Layout.preferredWidth: col.preferredWidth }
            Players { Layout.preferredWidth: col.preferredWidth }
        }
    }
}
