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

    signal expireRequested(int notificationId)

    signal dismissRequested(int notificationId)

    function expire() {
        if (popup) {
            expireRequested(id)
            notification.expire()
        }
    }

    function dismiss() {
        dismissRequested(id)
        notification.dismiss()
    }
}