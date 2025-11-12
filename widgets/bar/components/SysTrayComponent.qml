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
    required property var modelData
    property var menu: SysTrayMenu {}
    iconSource: {
        let icon = modelData?.icon || "";
        if (!icon) return "";
        if (icon.includes("?path=")) {
            const [name, path] = icon.split("?path=");
            const fileName = name.substring(name.lastIndexOf("/") + 1);
            return `file://${path}/${fileName}`;
        }
        return icon;
    }
    iconColor: Theme.colors.white
    iconSize: 25
    onClicked: menu.toggle(modelData)

    Component.onCompleted: {
        menu.modelData = modelData;
    }
}


