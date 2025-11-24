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
    id: deviceListView
    implicitHeight: contentHeight
    Layout.fillWidth: true
    clip: true
    model: ScriptModel {
        values: Mpris.players.values
    }
    delegate: PlayerComponent {}
}
