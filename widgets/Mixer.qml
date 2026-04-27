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

    PanelWindow {
        property var modelData
        id: window
        color: "transparent"
        screen: modelData
        mask: Region { item: col }
        focusable: window.isVisible
        implicitWidth: col.implicitWidth
        visible: root.visible
        anchors.right: true
        exclusiveZone: 0

        HyprlandFocusGrab {
            id: grab
            windows: [ window ]
            active: root.visible
        }           

        ColumnLayout {
            id: col
            focus: true
            property int preferredWidth: 500

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
