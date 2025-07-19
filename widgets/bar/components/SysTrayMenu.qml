import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland

import qs.config
import qs.utils

Scope {
	id: root
	property bool visible: false
    
    function open(modelData) {
        console.log(modelData.hasMenu)
        // root.visible = true
    }

    LazyLoader {
		active: root.visible

        PanelWindow {
            id: window
            screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? null
            exclusiveZone: 0
            color: Theme.colors.background
            visible: root.visible
            WlrLayershell.layer: WlrLayer.Overlay

            implicitHeight: 200
            implicitWidth: 300

            anchors {
                top: true            
                right: true
            }

            ColumnLayout {
                Rectangle {
                    implicitHeight: 100
                    implicitWidth: 100
                    color: Theme.colors.blue
                }
            }
        }
    }
}