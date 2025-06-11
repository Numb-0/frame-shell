import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import "root:/utils"
import "root:/config"

RowLayout {
    id: root
    PwObjectTracker { objects: [audioSink] }
    property PwNode audioSink: Pipewire.defaultAudioSink

    property var volumeIcons: ({
        muted: "audio-volume-muted-symbolic",
        low: "audio-volume-low-symbolic",
        medium: "audio-volume-medium-symbolic",
        high: "audio-volume-high-symbolic"
    })

    function getVolumeIcon(volume) {
        if (audioSink?.audio?.muted) return volumeIcons.muted
        if (volume <= 0) return volumeIcons.muted
        if (volume < 0.33) return volumeIcons.low
        if (volume < 0.66) return volumeIcons.medium
        return volumeIcons.high
    }

    Slider {
        id: control
        Layout.preferredWidth: 80
        Layout.preferredHeight: 15
        value: audioSink?.audio?.volume ?? 0
        from: 0
        to: 1
        onValueChanged: audioSink.audio.volume = value

        background: Rectangle {
            color: Theme.colors.backgroundHighlight
            ColorBehavior on color {}
            border.width: 0
            width: control.availableWidth
            height: control.availableHeight

            Rectangle {
                width: control.visualPosition * parent.width
                height: parent.height
                color: Theme.colors.green
                ColorBehavior on color {}
            }
        }

        handle: Rectangle {
            width: 10
            height: parent.height
            x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
            y: control.topPadding + control.availableHeight / 2 - height / 2
            color: Theme.colors.green
            ColorBehavior on color {}
        }
    }

    Loader {
        active: root.audioSink !== null
        sourceComponent: Icon {
            iconSource: Quickshell.iconPath(getVolumeIcon(audioSink?.audio?.volume))
            iconColor: Theme.colors.green
        }
    }
}