pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import qs.config
import qs.utils.components
import qs.utils.animations
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
            Region { item: root.notifications.length > 0 ? notifmask : null }
            Region { item: root.notifications.length > 0 ? clearButton : null }
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

        HoldButton {
            id: clearButton
            visible: root.notifications.length > 0
            x: root.notificationWidth + Config.spacing
            y: 0
            iconName: "clear_all"
            iconColor: Theme.colors.base08
            iconSize: 30
            iconPadding: 12
            onTriggered: {
                fadeOutAnim.restart();
                NotificationManager.clearAll();
            }

            // reset once hidden so it reappears at full opacity/scale next time
            onVisibleChanged: if (!visible) {
                opacity = 1;
                scale = 1;
            }

            Animations.PopOut {
                id: fadeOutAnim
                target: clearButton
                targetScale: 0
                targetOpacity: 0
            }

            Rectangle {
                parent: clearButton.iconBackground
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height)
                height: width
                radius: width / 2
                color: Theme.colors.base01
                z: -1
            }
        }
    }
}