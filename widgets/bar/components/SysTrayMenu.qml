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
import qs.utils.behaviors
import qs.utils.components

Scope {
	id: root
	property bool visible: SysTrayMenuManager.activeMenuId === modelData.id
    required property var modelData

    function toggle() {
        SysTrayMenuManager.setActiveMenu(modelData)
    }

    PanelWindow {
        id: window
        screen: Quickshell.screens.find(screen => Hyprland.monitorFor(screen) === Hyprland.focusedMonitor) ?? null
        exclusiveZone: 0
        color: "transparent"
        implicitHeight: col.implicitHeight + Config.spacing * 2
        visible: root.visible
        mask: Region { item: background }

        anchors {
            top: true
            right: true
            left: true
        }
        
        margins {
            top: Config.spacing
            left: Config.spacing
            right: Config.spacing
        }

        QsMenuOpener {
            id: opener
            menu: modelData.menu
        }

        Rectangle {
            id: background
            color: Theme.colors.base01
            radius: Config.rounding
            implicitWidth: col.implicitWidth + Config.spacing * 2
            implicitHeight: col.implicitHeight + Config.spacing * 2
            anchors.right: parent.right
        }

        HyprlandFocusGrab {
			id: grab
			windows: [ window ]
			active: root.visible
			onCleared: SysTrayMenuManager.activeMenuId = null
		}

        ColumnLayout {
            id: col
            anchors.centerIn: background
            spacing: 10
            ListView {
                id: menuListView
                implicitWidth: 280
                implicitHeight: contentHeight
                model: ScriptModel {
                    values: opener.children.values.filter(m => m.text != "")
                }
                delegate: Button {
                    implicitWidth: menuListView.implicitWidth
                    onClicked: {
                        root.visible = false
                        modelData.triggered()
                    }
                    contentItem: CustomText {
                        text: modelData.text
                    }
                    background: Rectangle {
                        radius: Config.rounding
                        color: parent.hovered ? Theme.colors.base02 : Theme.colors.base01
                        ColorBehavior on color { duration: 500 }
                    }
                }
            }
        }
    }
}
