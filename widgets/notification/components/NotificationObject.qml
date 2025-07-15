import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications


import "root:/config"
import "root:/utils"

QtObject {
    id: root
    required property var notification
    property int id: notification?.id || 0
    property list<var> actions: notification?.actions?.map(action => ({
        identifier: action.identifier || "",
        text: action.text || "",
    })) || []
    property bool popup: true
    property string appIcon: notification?.appIcon || ""
    property string appName: notification?.appName || "Unknown"
    property string body: notification?.body || ""
    property string image: notification?.image || ""
    property string summary: notification?.summary || ""
    property double time: Date.now()
    property string urgency: notification?.urgency
    property int expireTimeout: urgency === NotificationUrgency.Critical ? 10000 : 5000
    
    property Timer expireTimer: Timer {
        interval: root.expireTimeout
        onTriggered: expire()
    }

    signal expireRequested(int notificationId)

    signal dismissRequested(int notificationId)

    function expire() {
        if (popup) {
            expireTimer.stop()
            expireRequested(id)
            notification.expire()
        }
    }

    function dismiss() {
        expireTimer.stop()
        dismissRequested(id)
        notification.dismiss()
    }

    Component.onCompleted: {
        // console.log(notification.actions)
        // console.log(notification.summary)
        // console.log(notification.image)
        // console.log(notification.body)
        // console.log(root.urgency)
        expireTimer.start()
    }
}