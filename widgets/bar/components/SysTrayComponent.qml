import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

import qs.utils
import qs.config


IconButton {
    id: iconButton
    required property var modelData
    property var menu: SysTrayMenu { modelData: iconButton.modelData }
    iconSource: Quickshell.iconPath(iconDict[modelData?.title || modelData?.tooltipTitle] || modelData?.title.toLowerCase())
    iconSize: 30
    onClicked: menu.toggle()
    property var iconDict: {
        "DiscordCanary": "discord-canary",
    }
}


