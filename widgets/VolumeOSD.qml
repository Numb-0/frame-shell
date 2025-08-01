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

			WlrLayershell.exclusionMode: ExclusionMode.Ignore
			implicitWidth: 400
			implicitHeight: 50
			color: "transparent"

			mask: Region {}

			Rectangle {
				anchors.fill: parent
				color: Theme.colors.background

				RowLayout {
					anchors {
						fill: parent
						leftMargin: 10
						rightMargin: 15
					}

					IconButton {
						iconSource: Quickshell.iconPath("audio-volume-high-symbolic")
						iconColor: Theme.colors.green
					}

					Rectangle {
						Layout.fillWidth: true

						implicitHeight: 10
						color: Theme.colors.backgroundHighlight

						Rectangle {
							color: Theme.colors.green
							anchors {
								left: parent.left
								top: parent.top
								bottom: parent.bottom
							}

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
}