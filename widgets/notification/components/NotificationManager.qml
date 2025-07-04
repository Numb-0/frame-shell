pragma Singleton

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.Notifications

import "root:/config"
import "root:/utils"

Singleton {
    id: root
    property var list: []
    property Component notificationComponent: Qt.createComponent("NotificationObject.qml")

    NotificationServer {
        id: notifServer
        actionIconsSupported: true
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        imageSupported: true
        keepOnReload: true
        persistenceSupported: true

        onNotification: (notification) => {
            notification.tracked = true
            if (!notification) return;
            let notifObj;
            notifObj = notificationComponent.createObject(root, {
                notification: notification
            });

            notifObj.removeRequested.connect(function(notificationId) {
                root.list = root.list.filter(n => n.id !== notificationId)
                notification.expire() 
            })

            root.list.push(notifObj)
            root.listChanged();
            console.log("✅ Notification added:", notifServer.trackedNotifications.values);
        }
    }
}