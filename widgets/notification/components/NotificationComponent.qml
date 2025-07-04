import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications


import "root:/config"
import "root:/utils"

Rectangle {
    property int padding: 20
    color: Theme.colors.backgroundAlt
    implicitWidth: notifbtn.implicitWidth + padding
    implicitHeight: notifbtn.implicitHeight + padding
    ColumnLayout {
        id: notifbtn
        anchors.centerIn: parent
        CustomText {
            text: modelData.summary
        }
        CustomText {
            text: modelData.id
        }
    }

    signal resizeList(int width)

    ListView.onAdd: resizeToNotification()

    function resizeToNotification() {
        // Resize width only if needed
        window.implicitWidth = window.implicitWidth < implicitWidth ? implicitWidth : window.implicitWidth 
    }
}

