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
        property var currentMonitor: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name)
        screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? null
        exclusiveZone: 0
        color: "transparent"
        margins.top: 20

        anchors {
            top: true
            left: true
            bottom: true
            right: true
        }
        
        mask: Region {
            item: maskRect
        }

        onCurrentMonitorChanged: {
            if (notifList.count > 0) return
            window.screen = window.currentMonitor
        }

        Item {
            id: maskRect
            x: 0
            y: 0
            width: notifList.contentItem.childrenRect.width
            height: notifList.contentHeight
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

            add: Transition {
                ParallelAnimation {
                    NumberAnimation { 
                        properties: "x"
                        duration: 400
                        from: -300
                        to: 0
                        easing.type: Easing.OutCubic
                    }
                    NumberAnimation { 
                        properties: "opacity"
                        duration: 350
                        from: 0
                        to: 1
                        easing.type: Easing.OutCubic
                    }
                }
            }

            remove: Transition {
                ParallelAnimation {
                    NumberAnimation { 
                        properties: "x"
                        duration: 350
                        to: -300
                        easing.type: Easing.InCubic
                    }
                    NumberAnimation { 
                        properties: "opacity"
                        duration: 300
                        to: 0
                        easing.type: Easing.InCubic
                    }
                }
            }

            displaced: Transition {
                NumberAnimation { 
                    properties: "y"
                    duration: 400
                    easing.type: Easing.OutCubic
                }
            }

            moveDisplaced: Transition {
                NumberAnimation {
                    properties: "y"
                    duration: 400
                    easing.type: Easing.OutCubic
                }
            }
        }   
    }
}
