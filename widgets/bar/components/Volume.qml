import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import qs.utils
import qs.config

RowLayout {
    id: root
    PwObjectTracker { objects: [audioSink] }
    property PwNode audioSink: Pipewire.defaultAudioSink

    property var volumeIcons: ({
        muted: "volume_off",
        low: "volume_mute",
        medium: "volume_down",
        high: "volume_up"
    })

    function getVolumeIcon() {
        const volume = audioSink?.audio?.volume
        if (audioSink?.audio?.muted) return volumeIcons.muted
        if (volume <= 0) return volumeIcons.muted
        if (volume < 0.33) return volumeIcons.low
        if (volume < 0.66) return volumeIcons.medium
        return volumeIcons.high
    }

    Slider {
        id: volumeSlider
        Layout.preferredWidth: 80
        Layout.preferredHeight: 15
        value: audioSink?.audio?.volume ?? 0
        from: 0
        to: 1
        onValueChanged: audioSink.audio.volume = value

        background: Rectangle {
            color: Theme.colors.backgroundHighlight
            ColorBehavior on color {}
            radius: Config.rounding

            Rectangle {
                width: volumeSlider.visualPosition * parent.width
                height: parent.height
                color: Theme.colors.green
                ColorBehavior on color {}
                radius: Config.rounding
            }
        }

        handle: Rectangle {
            x: volumeSlider.visualPosition * (volumeSlider.implicitWidth - width)
            y: volumeSlider.implicitHeight / 2 - height / 2
            color: Theme.colors.green
            ColorBehavior on color {}
            radius: Config.rounding
        }
    }

    CustomText {
        id: percentageText
        property bool show: false
        text: Math.round(audioSink?.audio?.volume * 100) + '%'
        color: Theme.colors.green
        opacity: show ? 1 : 0
        Layout.preferredWidth: show ? implicitWidth : 0
        Behavior on Layout.preferredWidth { 
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic } 
        }
        Behavior on opacity { 
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic } 
        }
    }

    MaterialButton {
        iconName: getVolumeIcon()
        iconColor: Theme.colors.green
        onHoveredChanged: percentageText.show = hovered
    }
}