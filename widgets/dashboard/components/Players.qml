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
    Layout.margins: Config.rounding * 2
    spacing: 20
    model: ScriptModel {
        values: Mpris.players.values.filter(p => p.canPlay)
    }
    delegate: PlayerComponent {}
    
    Behavior on implicitHeight {
        enabled: root.visible
        NumberAnimation {
            duration: 600
            easing.type: Easing.OutCubic
        }
    }

    Component.onCompleted: {
        console.log(Mpris.players.values)
    }
    
    remove: Transition {
        enabled: root.visible
        ParallelAnimation {
            NumberAnimation {
                properties: "opacity"
                from: 1
                to: 0
                duration: 600
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                properties: "scale"
                from: 1
                to: 0.7
                duration: 600
                easing.type: Easing.InBack
            }
        }
    }
}