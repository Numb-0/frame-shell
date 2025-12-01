import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

import qs.utils
import qs.config

Rectangle {
    id: notif
    property int padding: 10
    color: Theme.colors.backgroundAlt
    implicitWidth: notifbtn.implicitWidth + padding
    implicitHeight: notifbtn.implicitHeight + padding
    topRightRadius: Config.rounding
    bottomRightRadius: Config.rounding
    ColumnLayout {
        id: notifbtn
        anchors.centerIn: parent
        RowLayout {
            CustomText {
                Layout.fillWidth: true
                Layout.maximumWidth: window.width/3
                text: modelData.summary
                // wrapMode: Text.Wrap
                elide: Text.ElideRight
                // maximumLineCount: 2
            }
            MaterialButton {
                iconPadding: 2
                // backgroundColor: Theme.colors.yellow
                iconName: "close"
                iconColor: Theme.colors.red
                onClicked: modelData.dismiss()
            }
        }
        CustomText {
            Layout.maximumWidth: window.width
            Layout.fillWidth: true
            text: modelData.body
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            maximumLineCount: 2
        }
        Image {
            source: modelData.image
            sourceSize.width: 50
            sourceSize.height: 50
        }
    }
}

