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
    property var menu: SysTrayMenu
    visible: SystemTray.items.values.length > 0
    // Layout.rightMargin: 10
    // Layout.leftMargin: 10
    Repeater {
        model: ScriptModel { values: SystemTray.items.values }
        delegate: SysTrayComponent { menu: systray.menu }
    }
}