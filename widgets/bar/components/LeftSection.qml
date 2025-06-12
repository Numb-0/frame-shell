import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:/config"

ColumnLayout {
    Layout.alignment: Qt.AlignLeft
    Layout.leftMargin: 10
    spacing: 10
    
    // Button {
    //     text: "Change Theme"
    //     background: Rectangle {
    //         color: Theme.colors.background
    //         border.color: Theme.colors.blue
    //         border.width: 1
    //     }
    //     font.family: "JetBrains Mono"
    //     font.weight: Font.Bold
    //     onClicked: Theme.nextTheme()
    // }

    Workspaces {}
} 