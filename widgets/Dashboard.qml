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
        screen: Quickshell.screens.find(screen => Hyprland.monitorFor(screen) === Hyprland.focusedMonitor) ?? null
        visible: root.visible
        color: "transparent"
        mask: Region { item: background }
        implicitWidth: col.preferredWidth
        implicitHeight: col.implicitHeight
        focusable: true
        exclusiveZone: 0
        anchors {
            top: true
            bottom: true
        }
        
        margins.top: Config.spacing
        
        Rectangle {
            id: background
            anchors.right: parent.right
            anchors.left: parent.left
            implicitHeight: col.implicitHeight
            color: Theme.colors.backgroundAlt
            radius: Config.rounding
        }
        

        ColumnLayout {
            id: col
            focus: true
            spacing: 0
            property int preferredWidth: 500
            anchors.fill: background
            Keys.onEscapePressed: root.visible = false

            Bluetooth { Layout.preferredWidth: col.preferredWidth }
            PowerProfiles { Layout.preferredWidth: col.preferredWidth }
            Brightness { Layout.preferredWidth: col.preferredWidth }
            Volume { Layout.preferredWidth: col.preferredWidth }
            Players { Layout.preferredWidth: col.preferredWidth }
        }
    }
}
