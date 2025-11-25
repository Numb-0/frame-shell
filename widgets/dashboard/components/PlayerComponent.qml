import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.config
import qs.utils

RowLayout {
    required property var modelData
    spacing: 0
    IconButton {
        visible: modelData.desktopEntry !== ""
        iconSource: Quickshell.iconPath(modelData.desktopEntry)
        iconSize: 25
        iconPadding: 10
        // Component.onCompleted: console.log("Icon source:", modelData.desktopEntry)
    }
    MaterialButton {
        // Fallback icon when no desktop entry is available
        visible: modelData.desktopEntry == ""
        iconName: "music_note"
        iconColor: Theme.colors.green
    }
    ColumnLayout {
        Layout.alignment: Qt.AlignVCenter
        spacing: 0
        CustomText {
            text: modelData.trackTitle
            font.pixelSize: 15
        }
        RowLayout { 
            spacing: 0
            MaterialButton {
                iconName: "skip_previous"
                iconColor: Theme.colors.green
                iconPadding: 0
                enabled: modelData.canGoPrevious
                onClicked: modelData.previous()
            }
            MaterialButton {
                id: playPauseButton
                iconName: modelData.isPlaying ? "pause" : "play_arrow"
                iconColor: Theme.colors.green
                iconPadding: 0
                onClicked: modelData.togglePlaying() 
            }
            MaterialButton {
                iconName: "skip_next"
                iconColor: Theme.colors.green
                iconPadding: 0
                enabled: modelData.canGoNext
                onClicked: modelData.next()
            }
        }
    }
}