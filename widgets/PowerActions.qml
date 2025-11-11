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

	LazyLoader {
		active: root.visible

		PanelWindow {
			id: window
			property int padding: 10
			focusable: true
			exclusiveZone: 0
			// Wayland
			Component.onCompleted: {
				if (WlrLayershell != null) {
					WlrLayershell.keyboardFocus = WlrKeyboardFocus.Exclusive
				}
			}

			implicitWidth: row.width + padding * 2
			implicitHeight: row.height + padding * 2
			anchors.bottom: true
			margins.bottom: screen.height / 2
			color: "transparent"
			Rectangle {
				id: background
				anchors.fill: parent
				color: Theme.colors.backgroundAlt
				radius: Config.rounding
				ColorBehavior on color {}
			}
			
			RowLayout {
				id: row
				spacing: 10
				anchors.centerIn: parent
				Keys.onEscapePressed: root.visible = false

				MaterialButton {
					id: themebutton
					iconName: Config.theme === "gruvbox" ? "light_mode" : "dark_mode"
					iconColor: Theme.colors.yellow
					iconSize: 40
					backgroundColor: Theme.colors.backgroundHighlight
					onClicked: activate()
					onFocusChanged: (focus) => buttonBackground.opacity = focus ? 1 : 0.0
					Keys.onPressed: (event) => {
						if (event.key === Qt.Key_Right) {
							powerbutton.focus = true
						}
					}
					Keys.onReturnPressed: activate()

					function activate() { Theme.nextTheme(); rotate.start() }

					RotationAnimation on materialIcon.rotation {
						id: rotate
						from: themebutton.materialIcon.rotation
						to: themebutton.materialIcon.rotation - 360
						duration: 1600
						easing { type: Easing.OutBack; overshoot: 1 }
					}

					Component.onCompleted: {
						focus = true
					}
				}

				MaterialButton {
					id: powerbutton
					iconName: "mode_off_on"
					iconColor: Theme.colors.red
					iconSize: 40
					backgroundColor: Theme.colors.backgroundHighlight
					onClicked: activate()
					onFocusChanged: (focus) => buttonBackground.opacity = focus ? 1 : 0.0
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
						buttonBackground.opacity = 0.0
					}
				}

				MaterialButton {
					id: rebootbutton
					iconName: "refresh"
					iconColor: Theme.colors.green
					iconSize: 40
					backgroundColor: Theme.colors.backgroundHighlight
					onClicked: activate()
					onFocusChanged: (focus) => buttonBackground.opacity = focus ? 1 : 0.0
					Keys.onPressed: (event) => {
						if (event.key === Qt.Key_Left) {
							powerbutton.focus = true
						}
					}
					Keys.onReturnPressed: activate()

					function activate() { reboot.running = true }
					Component.onCompleted: {
						buttonBackground.opacity = 0.0
					}
				}
			}
	    }
    }
}
