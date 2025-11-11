import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.Notifications

import qs.config
import qs.utils
import qs.widgets.notification.components

Scope {
	id: root
    PanelWindow {
        id: window
        screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? null
        exclusiveZone: 0
        color: "transparent"
        margins.top: 20
        implicitWidth: 600

        anchors {
            top: true
            left: true
            bottom: true
        }
        // WlrLayershell.layer: WlrLayer.Overlay
        
        mask: Region {
            item: notifList.contentItem
        }

        ListView {
            id: notifList
            model: ScriptModel {
                values: NotificationManager.list
            }
            anchors.fill: parent
            highlightFollowsCurrentItem: false
            delegate: NotificationComponent {}
            spacing: 5

            remove: Transition {
                ParallelAnimation {
                    NumberAnimation { properties: "x"; duration: 500; to: -300; easing.type: Easing.InOutQuad }
                    NumberAnimation { properties: "opacity"; duration: 400; to: 0; easing.type: Easing.InOutQuad }
                }
            }
            add: Transition {
                NumberAnimation { properties: "x"; duration: 500; from: -300; to: 0; easing.type: Easing.OutExpo }
                // NumberAnimation { properties: "opacity"; duration: 400; from: 0; to: 1; easing.type: Easing.OutExpo }
            }
            displaced: Transition {
                SequentialAnimation {
                    NumberAnimation { properties: "y"; duration: 500; easing.type: Easing.OutExpo }
                }
            }
        }   
    }
}
