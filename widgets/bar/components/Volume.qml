import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import qs.config
import qs.utils.behaviors
import qs.utils.components

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

    ThemedSlider {
        Layout.preferredWidth: 80
        value: audioSink?.audio?.volume ?? 0
        from: 0
        to: 1
        onValueChanged: audioSink.audio.volume = value
    }

    CustomText {
        id: percentageText
        property bool show: false
        text: Math.round(audioSink?.audio?.volume * 100) + '%'
        color: Theme.colors.base0B
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
        iconColor: Theme.colors.base0B
        onHoveredChanged: percentageText.show = hovered
    }
}