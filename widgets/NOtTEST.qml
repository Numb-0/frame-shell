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
        // color: "blue"
        color: "transparent"
        screen: Quickshell.screens.find(screen => Hyprland.monitorFor(screen) === Hyprland.focusedMonitor) ?? null
        mask: Region {
            item: notifList.count > 0 ? maskBounds : null
        }

        Item {
            Rectangle {
                anchors.fill: parent
                color: "yellow"
            }
            id: maskBounds
            anchors.horizontalCenter: notifList.horizontalCenter
            anchors.top: notifList.top
            implicitWidth: notifList.width
            implicitHeight: notifList.contentHeight
        }

        ListView {
            id: notifList
            property int notifWidth: 600
            property int notifHeight: 80
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: Config.spacing

            implicitWidth: notifWidth
            height: parent.height
            interactive: false

            model: ScriptModel {
                values: root.notifications
            }
            spacing: 0

            delegate: NotificationComponent { }
            add: Transition { }
            displaced: Transition {
                NumberAnimation {
                    properties: "y"
                    duration: 450
                    easing.type: Easing.OutQuint
                }
            }
        }
    }
}