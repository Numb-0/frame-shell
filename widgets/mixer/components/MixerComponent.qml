import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import qs.utils
import qs.config

ColumnLayout {
    id: root
    // Layout.fillWidth: true
    spacing: 0

    // Bind the PwNode for proper property updates
    PwObjectTracker { objects: [modelData] }

    function getAppIcon() {
        const iconName = modelData.properties["application.icon-name"] || ""
        
        const iconMap = {
            "audio-card": "speaker",
            "audio-headphones": "headphones",
            "audio-headset": "headset_mic",
            "audio-speakers": "speaker",
            "audio-input-microphone": "mic",
            "microphone": "mic",
            "multimedia-player": "music_note",
            "firefox": "web",
            "chrome": "web",
            "chromium": "web",
            "spotify": "music_note",
            "vlc": "play_circle"
        }
        
        if (iconMap[iconName]) return iconMap[iconName]
        if (iconName) return "audio_file"
        return modelData.isSink ? "speaker" : "mic"
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 90
        Layout.topMargin: 8
        Layout.leftMargin: 8
        Layout.rightMargin: 8
        Layout.bottomMargin: 8
        color: Theme.colors.backgroundHighlight
        radius: Config.rounding

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            // Icon and Name Section
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                MaterialSymbol {
                    id: appIcon
                    icon: getAppIcon()
                    size: 32
                    color: Theme.colors.foreground
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    CustomText {
                        text: modelData.nickname || 
                              modelData.description || 
                              modelData.properties["application.name"] || 
                              modelData.name
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        font.weight: Font.Medium
                    }

                    CustomText {
                        text: modelData.isStream ? "Application" : "Device"
                        font.pixelSize: 10
                        opacity: 0.6
                    }
                }

                MaterialButton {
                    iconPadding: 2
                    iconSize: 24
                    iconName: Pipewire.defaultAudioSink?.id == modelData?.id ? "check_box" : "check_box_outline_blank"
                    iconColor: Theme.colors.foreground
                    visible: modelData.isSink && !modelData.isStream
                    onClicked: {
                        if (modelData.isSink && !modelData.isStream) {
                            Pipewire.preferredDefaultAudioSink = modelData
                        }
                    } 
                }
            }

            // Volume Controls
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                // Mute Button
                MaterialButton {
                    iconPadding: 2
                    iconSize: 24
                    iconName: getVolumeIcon()
                    iconColor: modelData.audio?.muted ? Theme.colors.foreground : Theme.colors.green
                    // backgroundColor: modelData.audio?.muted ? Theme.colors.backgroundAlt : "transparent"
                    onClicked: {
                        if (modelData.audio) {
                            modelData.audio.muted = !modelData.audio.muted
                        }
                    }
                }

                // Volume Slider
                Slider {
                    id: volumeSlider
                    Layout.fillWidth: true
                    Layout.preferredHeight: 15
                    enabled: modelData.audio && !modelData.audio.muted
                    value: modelData.audio?.volume ?? 0
                    from: 0
                    to: 1
                    
                    onMoved: {
                        if (modelData.audio) {
                            modelData.audio.volume = value
                        }
                    }

                    background: Rectangle {
                        color: Theme.colors.backgroundAlt
                        ColorBehavior on color {}
                        radius: Config.rounding

                        Rectangle {
                            width: volumeSlider.visualPosition * parent.width
                            height: parent.height
                            color: volumeSlider.enabled ? Theme.colors.green : Theme.colors.foreground
                            ColorBehavior on color {}
                            radius: Config.rounding
                            opacity: volumeSlider.enabled ? 1.0 : 0.3
                        }
                    }

                    handle: Rectangle {
                        x: volumeSlider.visualPosition * (volumeSlider.implicitWidth - width)
                        y: volumeSlider.implicitHeight / 2 - height / 2
                        color: volumeSlider.enabled ? Theme.colors.green : Theme.colors.foreground
                        ColorBehavior on color {}
                        radius: Config.rounding
                        opacity: volumeSlider.enabled ? 1.0 : 0.5
                    }
                }

                // Volume Percentage
                CustomText {
                    text: Math.round((modelData.audio?.volume ?? 0) * 100) + "%"
                    Layout.preferredWidth: 45
                    Layout.leftMargin: 10
                    color: modelData.audio?.muted ? Theme.colors.foreground : Theme.colors.green
                    opacity: modelData.audio?.muted ? 0.5 : 1.0
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
    }

    function getVolumeIcon() {
        if (!modelData.audio) return "volume_off"
        
        const volume = modelData.audio.volume
        const muted = modelData.audio.muted
        const isSink = modelData.isSink

        if (muted || volume <= 0) {
            return isSink ? "volume_off" : "mic_off"
        }

        if (isSink) {
            if (volume < 0.33) return "volume_mute"
            if (volume < 0.66) return "volume_down"
            return "volume_up"
        } else {
            return "mic"
        }
    }
}
