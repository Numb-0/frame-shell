import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

import qs.utils
import qs.config
import qs.services

RowLayout {
    property int workspaceCount: 6
    
    Repeater {
        model: workspaceCount
        Rectangle {
            property int workspaceId: index + 1
            property var workspace: Hyprland.workspaces.values.find(ws => ws.id === workspaceId)
            property var hasClient: {
                HyprlandService.windowList.find(w => w.workspace.id === workspaceId) ? true : false
            }
            color: {
                if (workspace) {
                    if (workspace.focused) return Theme.colors.yellow;                
                    if (hasClient) return Theme.colors.purple;
                }
                return Theme.colors.blue
            }
            
            implicitHeight: 15
            implicitWidth: workspace && workspace.focused ? 35 : 15
            
            ColorBehavior on color {}
            Behavior on implicitWidth {
                NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
            }
        }
    }
}