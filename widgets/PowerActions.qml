import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland

import qs.config
import qs.utils

Scope {
	id: root
	property bool visible: false
	
	GlobalShortcut {
		name: "poweractions"
		onPressed: root.visible = !root.visible
	}

	Process {
		id: reboot
		command: ["reboot"]
	}

	Process {
		id: poweroff
		command: ["poweroff"]
	}

	Process {
		id: lock
		command: ["hyprlock"]
	}

	Variants {
		model: Quickshell.screens
		PanelWindow {
			property var modelData
			id: window
			focusable: true
			exclusiveZone: 0
			mask: Region {
				item: rect
			}
			screen: modelData
			anchors.bottom: true
			anchors.top: true
			property var padding: 10
			implicitWidth: row.implicitWidth + padding * 2
			color: "transparent"

			HyprlandFocusGrab {
				id: grab
				windows: [ window ]
				active: window.isVisible
			}

			property bool isVisible: root.visible && Hyprland.focusedMonitor?.name === modelData.name
			
			onIsVisibleChanged: {
				if (isVisible) {
					console.log("PowerActions visible on " + modelData.name)
					themebutton.focus = true
				} else {
					themebutton.focus = false
				}
			}

			Rectangle {
				id: rect
				color: Theme.colors.backgroundAlt
				radius: Config.rounding
				anchors.centerIn: parent
				ColorBehavior on color {}
				implicitWidth: row.implicitWidth + window.padding * 2
				implicitHeight: row.implicitHeight 

				states: [
					State {
						name: "hidden"
						when: !window.isVisible
						PropertyChanges { target: rect; height: 0}
						PropertyChanges { target: row; opacity: 0 }
					},
					State {
						name: "visible"
						when: window.isVisible
						PropertyChanges { target: rect; height: implicitHeight + window.padding * 2 }
						PropertyChanges { target: row; opacity: 1 }
					}
				]

				transitions: [
					Transition {
						from: "hidden"; to: "visible"
						NumberAnimation { properties: "height"; duration: 500; easing.type: Easing.OutBack }
						NumberAnimation { properties: "opacity"; duration: 400; easing.type: Easing.OutBack }
					},
					Transition {
						from: "visible"; to: "hidden"
						NumberAnimation { properties: "height"; duration: 500; easing.type: Easing.InBack }
						NumberAnimation { properties: "opacity"; duration: 400; easing.type: Easing.InBack }
					}
				]
			
				RowLayout {
					id: row
					spacing: 10
					Keys.onEscapePressed: root.visible = false
					anchors.centerIn: parent

					MaterialButton {
						id: themebutton
						iconName: Config.theme === "gruvbox" ? "light_mode" : "dark_mode"
						iconColor: Theme.colors.yellow
						iconSize: 40
						iconPadding: 5
						iconBackground.color: Theme.colors.backgroundHighlight
						onClicked: activate()
						onFocusChanged: (focus) => iconBackground.opacity = focus ? 1 : 0.0
						Keys.onPressed: (event) => {
							if (event.key === Qt.Key_Right) {
								powerbutton.focus = true
							}
						}
						Keys.onReturnPressed: activate()

						function activate() { Theme.nextTheme(); rotate.start() }

						RotationAnimation on iconSymbol.rotation {
							id: rotate
							from: themebutton.iconSymbol.rotation
							to: themebutton.iconSymbol.rotation - 360
							duration: 1600
							easing { type: Easing.OutBack; overshoot: 1 }
						}
					}

					MaterialButton {
						id: powerbutton
						iconName: "mode_off_on"
						iconColor: Theme.colors.red
						iconSize: 40
						iconPadding: 5
						iconBackground.color: Theme.colors.backgroundHighlight
						onClicked: activate()
						onFocusChanged: (focus) => iconBackground.opacity = focus ? 1 : 0.0
						Keys.onPressed: (event) => {
							if (event.key === Qt.Key_Right) {
								rebootbutton.focus = true
							} else if (event.key === Qt.Key_Left) {
								themebutton.focus = true
							}
						}
						Keys.onReturnPressed: activate()
						
						function activate() { poweroff.running = true }

						Component.onCompleted: {
							iconBackground.opacity = 0.0
						}
					}

					MaterialButton {
						id: rebootbutton
						iconName: "refresh"
						iconColor: Theme.colors.green
						iconSize: 40
						iconPadding: 5
						iconBackground.color: Theme.colors.backgroundHighlight
						onClicked: activate()
						onFocusChanged: (focus) => iconBackground.opacity = focus ? 1 : 0.0
						Keys.onPressed: (event) => {
							if (event.key === Qt.Key_Left) {
								powerbutton.focus = true
							} else if (event.key === Qt.Key_Right) {
								lockbutton.focus = true
							}

						}
						Keys.onReturnPressed: activate()

						function activate() { reboot.running = true }
						Component.onCompleted: {
							iconBackground.opacity = 0.0
						}
					}

					MaterialButton {
						id: lockbutton
						iconName: "lock"
						iconColor: Theme.colors.purple
						iconSize: 40
						iconPadding: 5
						iconBackground.color: Theme.colors.backgroundHighlight
						onClicked: activate()
						onFocusChanged: (focus) => iconBackground.opacity = focus ? 1 : 0.0
						Keys.onPressed: (event) => {
							if (event.key === Qt.Key_Left) {
								rebootbutton.focus = true
							}
						}
						Keys.onReturnPressed: activate()

						function activate() { lock.running = true }
						Component.onCompleted: {
							iconBackground.opacity = 0.0
						}
					}
				}
			}
		}
	}
}
