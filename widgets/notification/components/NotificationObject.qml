import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

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
    property real progress: 1.0
    property bool dismissing: false
    
    property PropertyAnimation expireAnimation: PropertyAnimation {
        target: root
        property: "progress"
        from: 1.0
        to: 0.0
        duration: root.expireTimeout
        running: false
        onStopped: {
            if (root.progress <= 0) {
                root.expire()
            }
        }
    }

    signal expireRequested(int notificationId)

    signal dismissRequested(int notificationId)

    function expire() {
        if (popup) {
            expireAnimation.stop()
            expireRequested(id)
            notification.expire()
        }
    }

    function dismiss() {
        expireAnimation.stop()
        dismissRequested(id)
        notification.dismiss()
    }

    Component.onCompleted: {
        // expireAnimation.start()
    }
}