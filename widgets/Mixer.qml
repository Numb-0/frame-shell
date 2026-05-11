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
    property var mixerWidth: 500

    GlobalShortcut {
		name: "mixer"
		onPressed: root.visible = !root.visible
	}

    PanelWindow {
        id: window
        color: "transparent"
        screen: Quickshell.screens.find(screen => Hyprland.monitorFor(screen) === Hyprland.focusedMonitor) ?? null
        mask: Region { item: bg }
        focusable: root.visible
        visible: root.visible
        implicitWidth: root.mixerWidth

        anchors {
            top: true
            right: true
            bottom: true
        }

        margins.top: Config.spacing
        margins.right: Config.spacing
        exclusionMode: ExclusionMode.Normal

        HyprlandFocusGrab {
            windows: [ window ]
            active: root.visible
            onCleared: root.visible = false
        }

        Rectangle {
            id: bg
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            implicitHeight: col.implicitHeight + Config.spacing * 2
            color: Theme.colors.backgroundAlt
            radius: Config.rounding

            ColumnLayout {
                id: col
                anchors.fill: parent
                anchors.margins: Config.spacing
                focus: root.visible
                spacing: Config.spacing
                Keys.onEscapePressed: root.visible = false
                Repeater {
                    model: ScriptModel {
                        values: Pipewire.nodes.values.filter(n => n.audio).sort((a, b) => a.name.localeCompare(b.name))
                    }
                    delegate: MixerComponent {
                        Layout.preferredWidth: root.mixerWidth - Config.spacing * 2
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }
    }
}
