import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland
// import Quickshell.Services.Notifications

import "root:/config"
import "root:/utils"
import "root:/widgets/dashboard/components"

Scope {
	id: root
	property bool visible: false

    GlobalShortcut {
		name: "dashboard"
		onPressed: root.visible = !root.visible
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
            // WlrLayershell.exclusionMode: ExclusionMode.Ignore
            // WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            implicitHeight: 200
            implicitWidth: 300

            anchors {
                top: true            
                right: true
            }

            ColumnLayout {
                Keys.onEscapePressed: {
                    root.visible = false
                }
                RowLayout {
                    Bluetooth {}
                }
            }
        }
    }
}