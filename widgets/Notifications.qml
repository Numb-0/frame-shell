pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import qs.config
import qs.widgets.notification.components


Scope {
    id: root
    property var notifications: NotificationManager.list
    property int notificationWidth: 600
    property int notificationHeight: 150

    PanelWindow {
        id: window

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        // exclusiveZone: 0
        color: "transparent"
        screen: Quickshell.screens.find(screen => Hyprland.monitorFor(screen) === Hyprland.focusedMonitor) ?? null
        mask: Region {
            item: notifications.length > 0 ? notifmask : null
        }
        margins.top: Config.spacing
        margins.left: Config.spacing

        Item {
            id: notifmask
            anchors {
                // horizontalCenter: parent.horizontalCenter
                // right: parent.right
                left: parent.left
                top: parent.top
            }
            width: root.notificationWidth
            height: root.notificationHeight
        }

        Repeater {
            id: notifRepeater
            model: ScriptModel {
                values: root.notifications
            }
            delegate: NotificationComponent {
                notificationWidth: root.notificationWidth
                notificationHeight: root.notificationHeight
            }
        }
    }
}