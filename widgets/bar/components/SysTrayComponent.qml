import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

import qs.utils
import qs.config

Item {
    required property var modelData
    required property var menu
    IconButton {
        anchors.centerIn: parent
        iconSource: {
            let icon = modelData?.icon || "";
            console.log(icon)
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
        onClicked: traymenu.open()
        QsMenuAnchor {
            id: traymenu
            anchor.edges: Edges.Top | Edges.Right
            anchor.window: bar
            
            menu: modelData.menu
            // onOpened: () => { 
            //     // console.log(anchor.rect)
            //     traymenu.anchor.edges = Edges.Top | Edges.Right
            //     // traymenu.anchor.updateAnchor()
            //     // traymenu.anchor.gravity = Edges.Bottom | Edges.Right
            // } 
        }
    }
}

