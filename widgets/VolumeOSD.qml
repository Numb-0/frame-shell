import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell.Wayland

import qs.config 
import qs.utils

Scope {
	id: root
	property PwNode audioSink: Pipewire.defaultAudioSink
	property bool visible: false
	PwObjectTracker {
		objects: [ audioSink ]
	}

	Loader {
		active: audioSink !== null
		sourceComponent: Connections {
			target: audioSink.audio

			function onVolumeChanged() {
				root.visible = true;
				hideTimer.restart();
			}
		}
	}

	Timer {
		id: hideTimer
		interval: 1500
		onTriggered: root.visible = false
	}

	LazyLoader {
		active: root.visible

		PanelWindow {
			anchors.bottom: true
			margins.bottom: screen.height / 5
			exclusiveZone: 0
			
			implicitWidth: 400
			implicitHeight: 50
			color: "transparent"

			mask: Region {}

			Rectangle {
				id: background
				anchors.fill: parent
				color: Theme.colors.backgroundAlt
				radius: Config.rounding
				ColorBehavior on color {}
			}
			RowLayout {
				anchors {
					fill: parent
					leftMargin: 10
					rightMargin: 15
				}

				MaterialSymbol {
					fill: 1
					color: Theme.colors.green
					icon: {
						const volume = audioSink?.audio?.volume
						if (audioSink?.audio?.muted) return "volume_off"
						if (volume <= 0) return "volume_off"
						if (volume < 0.33) return "volume_mute"
						if (volume < 0.66) return "volume_down"
						return "volume_up"
					}
				}

				Rectangle {
					Layout.fillWidth: true

					implicitHeight: 10
					color: Theme.colors.backgroundHighlight
					radius: Config.rounding
					Rectangle {
						color: Theme.colors.green
						anchors {
							left: parent.left
							top: parent.top
							bottom: parent.bottom
						}
						radius: Config.rounding
						implicitWidth: parent.width * (audioSink?.audio.volume ?? 0)
						Behavior on implicitWidth {
							NumberAnimation {
								duration: 200
							}
						}
					}
				}
			}
		}
	}
}