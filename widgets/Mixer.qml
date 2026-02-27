import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.Pipewire

import qs.config
import qs.utils
import qs.widgets.mixer.components

Scope {
	id: root
	property bool visible: false

    GlobalShortcut {
		name: "mixer"
		onPressed: {
            root.visible = !root.visible
        }
	}

    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            id: window
            color: "transparent"
            screen: modelData
            mask: Region { item: shp }
            focusable: window.isVisible
            // implicitWidth: shp.implicitWidth
            implicitHeight: shp.implicitHeight
            anchors {
                left: true
                right: true
            }
            exclusiveZone: -1
            // margins.top: 40

            HyprlandFocusGrab {
                id: grab
                windows: [ window ]
                active: root.visible
            }

            property bool isVisible: root.visible && Hyprland.focusedMonitor?.name === modelData.name
           
            Shape {
                id: shp
                property real padding: Config.rounding * 2
                property real rounding: 0
                anchors.right: parent.right
                height: col.implicitHeight + Config.rounding * 4
                states: [
                    State {
                        name: "hidden"
                        when: !window.isVisible
                        PropertyChanges { target: shp; rounding: 0; width: 0 }
                    },
                    State {
                        name: "visible"
                        when: window.isVisible
                        PropertyChanges { target: shp; rounding: Config.rounding * 2; width: col.implicitWidth }
                    }
                ]

                transitions: [
                    Transition {
                        from: "hidden"; to: "visible"
                        ParallelAnimation {
                            NumberAnimation {
                                properties: "width"
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
                        from: "visible"; to: "hidden"
                        ParallelAnimation {
                            ParallelAnimation {
                                NumberAnimation {
                                    properties: "width"
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
                    startX: shp.width; startY: 0
                    PathQuad { x: shp.width - shp.rounding; y: shp.rounding; controlX: shp.width; controlY: shp.rounding }
                    PathLine { x: shp.rounding; y: shp.rounding }
                    PathQuad { x: 0; y: shp.rounding * 2; controlX: 0; controlY: shp.rounding }
                    PathLine { x: 0; y: shp.height - shp.rounding * 2 }
                    PathQuad { x: shp.rounding; y: shp.height - shp.rounding; controlX: 0; controlY: shp.height - shp.rounding }
                    PathLine { x: shp.width - shp.rounding ; y: shp.height - shp.rounding }
                    PathQuad { x: shp.width; y: shp.height; controlX: shp.width; controlY: shp.height - shp.rounding }
                    PathLine { x: shp.width; y: 0 }
                }
            }

            ColumnLayout {
                id: col
                focus: true
                property int preferredWidth: 500
                anchors.bottom: shp.bottom
                anchors.top: shp.top
                anchors.right: shp.right
                anchors.left: shp.left

                anchors.topMargin: shp.padding
                anchors.bottomMargin: shp.padding
                spacing: 0
                Keys.onEscapePressed: root.visible = false
                Repeater {
                    model: ScriptModel {
                        values: Pipewire.nodes.values.filter(n => n.audio)
                    }
                    MixerComponent { 
                        Layout.preferredWidth: col.preferredWidth 
                    }
                }
            }
        }
    }
}
