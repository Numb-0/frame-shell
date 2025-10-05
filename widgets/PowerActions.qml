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
			property int padding: 18
			WlrLayershell.exclusionMode: ExclusionMode.Ignore
			WlrLayershell.layer: WlrLayer.Overlay
			WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

			implicitWidth: row.width + padding * 2 + 8
			implicitHeight: row.height + padding * 2 
			anchors.bottom: true
			margins.bottom: screen.height / 2
			color: Theme.colors.background
			ColorBehavior on color {}
			
			RowLayout {
				id: row
				spacing: 20
				anchors.centerIn: parent
				Keys.onEscapePressed: root.visible = false

				MaterialButton {
					id: themebutton
					focus: true
					iconName: "details"
					iconColor: Theme.colors.yellow
					iconSize: 40
					onClicked: activate()
					
					RotationAnimation on rotation {
						id: rotate
						from: themebutton.rotation
						to: themebutton.rotation + 180
						duration: 400
						easing { type: Easing.OutBack; overshoot: 1 }
					}
					Keys.onPressed: (event) => {
						if (event.key === Qt.Key_Right) {
							powerbutton.focus = true
						}
					}
					Keys.onReturnPressed: activate()

					function activate() { Theme.nextTheme(); rotate.start() }
				}

				MaterialButton {
					id: powerbutton
					iconName: "mode_off_on"
					iconColor: Theme.colors.red
					iconSize: 40
					onClicked: activate()
					Keys.onPressed: (event) => {
						if (event.key === Qt.Key_Right) {
							rebootbutton.focus = true
						} else if (event.key === Qt.Key_Left) {
							themebutton.focus = true
						}
					}
					Keys.onReturnPressed: activate()
					
					function activate() { poweroff.running = true }
				}

				MaterialButton {
					id: rebootbutton
					iconName: "refresh"
					iconColor: Theme.colors.green
					iconSize: 40
					onClicked: activate()
					Keys.onPressed: (event) => {
						if (event.key === Qt.Key_Left) {
							powerbutton.focus = true
						}
					}
					Keys.onReturnPressed: activate()

					function activate() { reboot.running = true }
				}
			}
	    }
    }
}
