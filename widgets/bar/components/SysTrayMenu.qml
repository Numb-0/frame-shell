pragma Singleton
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

Singleton {
	id: root
	property bool visible: false
    property var modelData
    property var newModelData

    function toggle(modelData) {
        if (root.visible && root.modelData === modelData) {
            root.visible = false
            return
        }

        root.visible = false
        root.newModelData = modelData
        switchTimer.restart()
    }

    Timer {
		id: switchTimer
		interval: 500
		onTriggered: {
            root.modelData = root.newModelData
            root.visible = true
        }
	}

    PanelWindow {
        id: window
        screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? Quickshell.primaryScreen
        exclusiveZone: -1
        margins.top: 40
        color: "transparent"
        implicitWidth: col.implicitWidth + col.anchors.margins * 2 + shp.margin * 2
        implicitHeight: col.implicitHeight + col.anchors.margins * 2 + shp.margin * 2
        mask: Region { item: shp }

        anchors {
            top: true
            right: true
        }

        QsMenuOpener {
            id: opener
            menu: modelData ? modelData.menu : null
        }

        // --- Animated shape background ---
        Shape {
            id: shp
            property real margin: 20
            property real roundingMax: 20
            property real rounding: 0
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: margin

            Behavior on height {
                NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
            }

            states: [
                State {
                    name: "hidden"
                    when: !root.visible
                    PropertyChanges { target: shp; rounding: 0; width: 0 }
                },
                State {
                    name: "visible"
                    when: root.visible
                    PropertyChanges { target: shp; rounding: roundingMax; width: parent.width - roundingMax * 2 }
                }
            ]

            transitions: [
                Transition {
                    from: "hidden"; to: "visible"
                    ParallelAnimation {
                        NumberAnimation { properties: "width"; duration: 500; easing.type: Easing.OutCubic }
                        NumberAnimation { properties: "rounding"; duration: 600; easing.type: Easing.OutBack }
                    }
                },
                Transition {
                    from: "visible"; to: "hidden"
                    ParallelAnimation {
                        NumberAnimation { properties: "width"; duration: 400; easing.type: Easing.InBack }
                        NumberAnimation { properties: "rounding"; duration: 500; easing.type: Easing.InCubic }
                    }
                }
            ]

            ShapePath {
                fillColor: Theme.colors.backgroundAlt
                strokeWidth: 0
                startX: -shp.rounding; startY: 0
                PathLine { x: shp.width; y: 0 }
                PathLine { x: shp.width; y: shp.height + shp.rounding }
                // Bottom-right corner
                PathQuad { x: shp.width - shp.rounding; y: shp.height; controlX: shp.width; controlY: shp.height }
                PathLine { x: shp.rounding; y: shp.height }
                // Bottom-left corner
                PathQuad { x: 0; y: shp.height - shp.rounding; controlX: 0; controlY: shp.height }
                PathLine { x: 0; y: shp.rounding }
                // Top-left corner
                PathQuad { x: -shp.rounding; y: 0; controlX: 0; controlY: 0 }
            }
        }

        // --- Menu content inside the animated shape ---
        ColumnLayout {
            id: col
            anchors.fill: shp
            anchors.margins: 10
            spacing: 10
            ListView {
                implicitWidth: 200
                implicitHeight: contentHeight
                model: ScriptModel {
                    values: opener.children.values.filter(m => m.text != "")
                }
                delegate: Button {
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    onClicked: {
                        root.visible = false
                        modelData.triggered()
                    }
                    contentItem: CustomText {
                        text: modelData.text
                    }
                    background: Rectangle {
                        radius: Config.rounding
                        color: parent.hovered ? Theme.colors.backgroundHighlight : Theme.colors.backgroundAlt
                        ColorBehavior on color { duration: 200 }
                    }
                }
            }
        }
    }
}
