pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import qs.utils
import qs.config
import qs.widgets.notification.components


Scope {
    id: root
    property var notifications: NotificationManager.list
    PanelWindow {
        id: window

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        exclusiveZone: 0
        color: "transparent"
        screen: Quickshell.screens.find(screen => Hyprland.monitorFor(screen) === Hyprland.focusedMonitor) ?? null
        mask: Region {
            item: notifications.length > 0 ? notifmask : null
        }
        margins.top: Config.spacing

        Item {
            id: notifmask
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
            }
            width: 600
            height: 150
            // Rectangle {
            //     anchors.fill: parent
            //     color: "transparent"
            //     border.color: "red"
            //     border.width: 1
            // }
        }

        Repeater {
            id: notifRepeater
            model: ScriptModel {
                values: root.notifications
            }
            delegate: NotificationComponent {}
        }
    }
}