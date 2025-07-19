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
    Layout.rightMargin: 10
    property var menu: SysTrayMenu {}
    Loader {
        active: SystemTray.items.values.length > 0
        Repeater {
            model: ScriptModel { values: SystemTray.items.values }
            delegate: SysTrayComponent { menu: systray.menu }
        }
    }
}