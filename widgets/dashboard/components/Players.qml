import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.config
import qs.utils

ListView {
    Layout.fillWidth: true
    implicitHeight: contentHeight
    interactive: false
    Layout.leftMargin: Config.rounding * 2
    Layout.rightMargin: Config.rounding * 2
    Layout.bottomMargin: Config.rounding * 2
    
    model: ScriptModel {
        values: Mpris.players.values.filter(p => p.canPlay)
    }
    delegate: PlayerComponent {}
    
    Behavior on implicitHeight {
        NumberAnimation {
            duration: 600
            easing.type: Easing.OutCubic
        }
    }
    
    add: Transition {
        ParallelAnimation {
            NumberAnimation {
                properties: "opacity"
                from: 0
                to: 1
                duration: 600
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                properties: "y"
                duration: 600
                easing.type: Easing.OutCubic
            }
        }
    }
    
    displaced: Transition {
        NumberAnimation {
            properties: "x,y"
            duration: 600
            easing.type: Easing.OutCubic
        }
    }
    
    remove: Transition {
        NumberAnimation {
            properties: "opacity"
            from: 1
            to: 0
            duration: 600
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            properties: "y"
            duration: 600
            easing.type: Easing.InCubic
        }
    }
}
