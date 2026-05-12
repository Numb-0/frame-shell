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
import qs.widgets.dashboard.components

Scope {
	id: root
	property bool visible: false
    PanelWindow {
        id: window
        screen: Quickshell.screens.find(screen => Hyprland.monitorFor(screen) === Hyprland.focusedMonitor) ?? null
        visible: root.visible
        color: "transparent"
        mask: Region { item: background }
        implicitWidth: col.preferredWidth
        implicitHeight: col.implicitHeight
        focusable: true
        // exclusiveZone: 0
        exclusionMode: ExclusionMode.Normal
        anchors {
            top: true
            bottom: true
        }

        ListView {
            id: listView
            model: ListModel {
                ListElement { name: "Network" }
                ListElement { name: "Audio" }
                ListElement { name: "Bluetooth" }
                ListElement { name: "Power" }
                ListElement { name: "Performance" }
                ListElement { name: "Storage" }
                ListElement { name: "Processes" }
                ListElement { name: "Services" }
                ListElement { name: "Hardware" }
                ListElement { name: "Software" }
            }
            delegate: DashboardButton {
                text: model.name
            }
        }
    }
}