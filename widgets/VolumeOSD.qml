import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

import "root:/config"
import "root:/utils"

Scope {
	id: root
	property PwNode audioSink: Pipewire.defaultAudioSink
	PwObjectTracker {
		objects: [ audioSink ]
	}

	Loader {
		active: audioSink !== null
		sourceComponent: Connections {
			target: audioSink.audio

			function onVolumeChanged() {
				root.shouldShowOsd = true;
				hideTimer.restart();
			}
		}
	}

	property bool shouldShowOsd: false

	Timer {
		id: hideTimer
		interval: 1500
		onTriggered: root.shouldShowOsd = false
	}

	LazyLoader {
		active: root.shouldShowOsd

		PanelWindow {
			anchors.bottom: true
			margins.bottom: screen.height / 5

			implicitWidth: 400
			implicitHeight: 50
			color: "transparent"

			mask: Region {}

			Rectangle {
				anchors.fill: parent
				// radius: height / 2
				color: Theme.colors.background

				RowLayout {
					anchors {
						fill: parent
						leftMargin: 10
						rightMargin: 15
					}

					Icon {
						iconSource: Quickshell.iconPath("audio-volume-high-symbolic")
						iconSize: 20
						iconColor: Theme.colors.green
					}

					Rectangle {
						Layout.fillWidth: true

						implicitHeight: 10
						// radius: 20
						color: Theme.colors.backgroundHighlight

						Rectangle {
							color: Theme.colors.green
							anchors {
								left: parent.left
								top: parent.top
								bottom: parent.bottom
							}

							implicitWidth: parent.width * (audioSink.audio.volume ?? 0)
							Behavior on implicitWidth {
								NumberAnimation {
									duration: 200
								}
							}
							// radius: parent.radius4
						}
					}
				}
			}
		}
	}
}