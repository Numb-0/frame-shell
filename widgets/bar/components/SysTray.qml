import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import qs.utils
import qs.config

RowLayout {
    id: systray
    visible: SystemTray.items.values.length > 0
    Repeater {
        model: ScriptModel { values: SystemTray.items.values }
        delegate: SysTrayComponent {}
    }
}