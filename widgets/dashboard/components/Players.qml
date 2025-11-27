import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.config
import qs.utils



ColumnLayout {
    Layout.fillWidth: true
    spacing: 10
    
    Repeater {
        model: ScriptModel {
            values: Mpris.players.values
        }
        delegate: PlayerComponent {}
    }
}
