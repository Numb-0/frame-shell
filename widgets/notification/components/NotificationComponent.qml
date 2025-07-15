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
    id: notif
    property int padding: 10
    color: Theme.colors.backgroundAlt
    implicitWidth: notifbtn.implicitWidth + padding
    implicitHeight: notifbtn.implicitHeight + padding
    ColumnLayout {
        id: notifbtn
        anchors.centerIn: parent
        RowLayout {
            CustomText {
                Layout.maximumWidth: 200
                text: modelData.summary
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                maximumLineCount: 2
            }
            IconButton {
                iconColor: Theme.colors.yellow
                iconSource: Quickshell.iconPath("window-close")
                onClicked: modelData.dismiss()
            }   
        }
        CustomText {
            Layout.maximumWidth: 200
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

    signal resizeList(int width)

    // ListView.onAdd: resizeToNotification()

    // function resizeToNotification() {
    //     let maxWidth = 0
    //     notifList.contentItem.children.forEach((nc) =>{
    //         maxWidth = nc.implicitWidth < maxWidth ? maxWidth : nc.implicitWidth
    //     })
    //     window.implicitWidth = maxWidth
    // }
}

