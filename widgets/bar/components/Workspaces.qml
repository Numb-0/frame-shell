import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

import "root:/utils"
import "root:/config"

RowLayout {
    property int workspaceCount: 6
    
    Repeater {
        model: workspaceCount
        Rectangle {
            property int workspaceId: index + 1
            property var workspace: Hyprland.workspaces.values.find(ws => ws.id === workspaceId)
            
            color: {
                if (!workspace) return Theme.colors.blue
                if (workspace.focused) return Theme.colors.yellow;                
                return Theme.colors.purple;
            }
            
            implicitHeight: 15
            implicitWidth: workspace && workspace.focused ? 35 : 15
            
            ColorBehavior on color {}
            Behavior on implicitWidth {
                NumberAnimation { duration: 200 }
            }
        }
    }
}