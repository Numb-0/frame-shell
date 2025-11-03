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
        exclusiveZone: 0
        color: "transparent"
        // Wayland/Hyprland
        screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? null
        mask: Region { item: shp }
        implicitHeight: 200
        implicitWidth: 300

        anchors {
            top: true            
            right: true
        }

        Shape {
            id: shp
            property real margin: 0
            property real rounding: Config.rounding
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: margin
            states: [
                State {
                    name: "hidden"
                    when: !root.visible
                    PropertyChanges { target: shp; margin: 0; width: 0 }
                },
                State {
                    name: "visible"
                    when: root.visible
                    PropertyChanges { target: shp; margin: 16; width: parent.width - margin * 2 }
                }
            ]

            transitions: [
                Transition {
                    from: "hidden"; to: "visible"
                    ParallelAnimation {
                        NumberAnimation { properties: "margin"; duration: 400; easing.type: Easing.InCirc }
                        NumberAnimation { properties: "width"; duration: 400; easing.type: Easing.InCubic }
                    }
                },
                Transition {
                    from: "visible"; to: "hidden"
                    ParallelAnimation {
                        NumberAnimation { properties: "margin"; duration: 400; easing.type: Easing.InCubic }
                        NumberAnimation { properties: "width"; duration: 300; easing.type: Easing.InCubic }
                    }
                }
            ]
            ShapePath {
                fillColor: Theme.colors.backgroundAlt
                strokeWidth: 0
                startX: -shp.margin; startY: -shp.margin
                PathLine { x: shp.width + shp.margin ; y: -shp.margin }
                PathLine { x: shp.width + shp.margin; y: shp.height + shp.margin }
                PathQuad { x: shp.width; y: shp.height; controlX: shp.width + shp.margin; controlY: shp.height }
                PathLine { x: shp.rounding; y: shp.height }
                PathQuad { x: 0; y: shp.height - shp.rounding; controlX: 0; controlY: shp.height }
                PathLine { x: 0; y: shp.rounding }
                PathQuad { x: -shp.margin; y: -shp.margin; controlX: 0; controlY: -shp.margin }
            }
        }

        ColumnLayout {
            anchors.fill: shp
            RowLayout {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.leftMargin: shp.margin
                Bluetooth {}
            }
        }
    }
}