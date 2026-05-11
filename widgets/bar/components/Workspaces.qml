import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland

import qs.utils
import qs.config
import qs.services

RowLayout {
    property int workspaceCount: 6
    
    Repeater {
        model: workspaceCount
        Rectangle {
            radius: Config.rounding
            property int workspaceId: index + 1
            property var workspace: Hyprland.workspaces.values.find(ws => ws.id === workspaceId)
            property var hasToplevel: workspace?.toplevels.values.length > 0
            color: {
                if (workspace) {
                    if (workspace.focused) return Theme.colors.base0A;                
                    if (hasToplevel) return Theme.colors.base0E;
                }
                return Theme.colors.base0D
            }
            
            implicitHeight: 15
            implicitWidth: workspace?.focused ? 35 : 15
            
            ColorBehavior on color {}
            Behavior on implicitWidth {
                NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: workspace.activate()
            }
            // IconButton {
            //     anchors.centerIn: parent
            //     visible: hasToplevel
            //     iconSource: Quickshell.iconPath(workspace?.toplevels.values[0]?.wayland.appId )
            //     iconSize: 15
            // }
        }
    }
}