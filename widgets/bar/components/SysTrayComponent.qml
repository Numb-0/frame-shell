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
    required property var menu
    iconSource: {
        let icon = modelData?.icon || "";
        // console.log(icon)
        if (!icon) return "";
        if (icon.includes("?path=")) {
            const [name, path] = icon.split("?path=");
            const fileName = name.substring(name.lastIndexOf("/") + 1);
            return `file://${path}/${fileName}`;
        }
        return icon;
    }
    iconColor: Theme.colors.white
    iconSize: 22
    onClicked: menu.toggle(modelData)
    // onClicked: traymenu.open()
    // QsMenuAnchor {
    //     id: traymenu
    //     anchor.edges: Edges.Bottom | Edges.Right
    //     anchor.window: bar
    //     anchor.rect.width: bar.width
    //     anchor.margins.top: bar.height
        
    //     menu: modelData.menu
    // }
}


