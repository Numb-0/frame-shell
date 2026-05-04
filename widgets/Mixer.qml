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
		onPressed: root.visible = !root.visible
	}

    PanelWindow {
        property var modelData
        id: window
        color: "transparent"
        screen: Quickshell.screens.find(screen => Hyprland.monitorFor(screen) === Hyprland.focusedMonitor) ?? null
        mask: Region { item: col }
        focusable: root.visible
        implicitWidth: col.implicitWidth
        visible: root.visible
        anchors {
            top: true
            right: true
            bottom: true
        }
        margins.top: Config.spacing
        margins.right: Config.spacing
        exclusiveZone: 0       

        ColumnLayout {
            id: col
            property int preferredWidth: 500
            focus: root.visible
            spacing: 0
            Keys.onEscapePressed: root.visible = false
            Repeater {
                model: ScriptModel {
                    values: Pipewire.nodes.values.filter(n => n.audio)
                }
                MixerComponent { Layout.preferredWidth: col.preferredWidth }
            }
        }
    }
}
