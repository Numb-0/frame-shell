import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower

import "root:/config"
import "root:/utils"

RowLayout {
    id: root
    property var battery: UPower.displayDevice
    
    ProgressBar {
        id: progress
        Layout.preferredWidth: 80
        Layout.preferredHeight: 15
        value: battery.percentage
        from: 0
        to: 1

        background: Rectangle {
            color: Theme.colors.backgroundHighlight
            ColorBehavior on color {}
            border.width: 0
        }

        contentItem: Item {
            Rectangle {
                width: parent.width * parent.parent.visualPosition
                height: parent.height
                color: progress.value < 0.3 ? Theme.colors.red : Theme.colors.yellow
                ColorBehavior on color {}
            }
        }
    }
    
    Loader {
        active: battery.iconName !== ""
        sourceComponent: Icon {
            iconSource: Quickshell.iconPath(battery.iconName)
            iconColor: Theme.colors.yellow
        }
    }
}
