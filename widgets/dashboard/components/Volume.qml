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
    spacing: 0

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

    MaterialButton {
        iconSize: 30
        iconName: getVolumeIcon()
        iconColor: Theme.colors.base0B
        iconPadding: 5
    }

    ThemedSlider {
        Layout.fillWidth: true
        value: audioSink?.audio?.volume ?? 0
        from: 0
        to: 1
        onValueChanged: audioSink.audio.volume = value
    }

    CustomText {
        text: Math.round(audioSink?.audio?.volume * 100) + "%"
        Layout.rightMargin: 15
        Layout.leftMargin: 10
        color: Theme.colors.base0B
    }
}