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
			WlrLayershell.exclusionMode: ExclusionMode.Ignore
			WlrLayershell.layer: WlrLayer.Overlay
			WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

			implicitWidth: row.width + padding * 2
			implicitHeight: row.height + padding * 2
			anchors.bottom: true
			margins.bottom: screen.height / 2
			color: Theme.colors.background
			ColorBehavior on color {}
			
			RowLayout {
				id: row
				anchors.centerIn: parent
				spacing: 10
				Keys.onEscapePressed: {
					root.visible = false
				}

				IconButton {
					id: themebutton
					focus: true
					iconSource: "root:/assets/icons/arrow-symbolic.svg"
					iconColor: Theme.colors.yellow
					iconSize: 40
					backgroundColor: focus ? Theme.colors.backgroundHighlight : "transparent"
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

				IconButton {
					id: powerbutton
					iconSource: Quickshell.iconPath("system-shutdown-symbolic")
					iconColor: Theme.colors.red
					iconSize: 20
					backgroundColor: focus ? Theme.colors.backgroundHighlight : "transparent"
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

				IconButton {
					id: rebootbutton
					iconSource: Quickshell.iconPath("system-reboot-symbolic")
					iconColor: Theme.colors.green
					iconSize: 20
					backgroundColor: focus ? Theme.colors.backgroundHighlight : "transparent"
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
