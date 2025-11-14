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

            notifObj.expireRequested.connect(function(notificationId) {
                root.list = root.list.filter(n => n.id !== notificationId)
            })

            notifObj.dismissRequested.connect(function(notificationId) {
                root.list = root.list.filter(n => n.id !== notificationId)
            })

            root.list.push(notifObj)
            root.listChanged();
        }
    }

    Process {
        id: sendNotification
    }

    function sendNotification(title, body) {
        sendNotification.exec(["notify-send", title, body]);
    }
}