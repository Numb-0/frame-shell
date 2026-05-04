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
            top: 10
            left: 10
            right: 10
        }

        QsMenuOpener {
            id: opener
            menu: modelData.menu
        }

        Rectangle {
            id: background
            color: Theme.colors.backgroundAlt
            radius: Config.rounding * 2
            implicitWidth: col.implicitWidth + Config.spacing * 2
            implicitHeight: col.implicitHeight + Config.spacing * 2
            anchors.right: parent.right
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
                        radius: Config.rounding * 2
                        color: parent.hovered ? Theme.colors.backgroundHighlight : Theme.colors.backgroundAlt
                        ColorBehavior on color { duration: 200 }
                    }
                }
            }
        }
    }
}
