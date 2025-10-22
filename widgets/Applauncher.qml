import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland
import "root:/config"
import "root:/utils"

Scope {
	id: root
	property bool visible: false
	property string searchText: ""
	
	GlobalShortcut {
		name: "applauncher"
		onPressed: root.visible = !root.visible
	}

	LazyLoader {
		active: root.visible

		PanelWindow {
			id: window
			WlrLayershell.exclusionMode: ExclusionMode.Ignore
			WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
			visible: root.visible
			implicitWidth: 340
			implicitHeight: 260
			// anchors.bottom: true
      		// margins.bottom: screen.height / 2
			anchors.top: true
			margins.top: 38

			// color: Theme.colors.background 
			// ColorBehavior on color {}
			color: "transparent"
			Rectangle {
				anchors.fill: parent
				color: Theme.colors.background
				radius: 10
				ColorBehavior on color {}
			}
			ColumnLayout {
				anchors.fill: parent
				Keys.onEscapePressed: {
					root.visible = false
				}
				TextField {
					id: searchBox
					Layout.fillWidth: true
					Layout.preferredHeight: 40
					// placeholderText: "Search applications..."
					focus: true
					font.bold: true
					font.family: "JetBrainsMono Nerd Font"
					color: Theme.colors.foreground
					background: Rectangle {
						radius: 10
						color: searchBox.focus ? Theme.colors.backgroundHighlight : Theme.colors.backgroundAlt
						ColorBehavior on color {}
					}
					onTextChanged: {
						root.searchText = text
						appsList.currentIndex = -1
					}
					onFocusChanged: (event) => { appsList.currentIndex = -1 }
					Keys.onPressed: (event) => {
						if (event.key === Qt.Key_Down) {
							appsList.forceActiveFocus()
							appsList.currentIndex = 0
						}
					}
					Keys.onReturnPressed: () => {
						appsList.itemAtIndex(0).activate()
						root.visible = false
						clear()
					}
				}

				ListView {
					id: appsList
					model: ScriptModel {
						values: DesktopEntries.applications.values.filter(entry => entry.name.toLowerCase().includes(root.searchText.toLowerCase()))
					}
					snapMode: ListView.SnapToItem
					Layout.fillWidth: true
					Layout.fillHeight: true
					clip: true
					spacing: 5
					highlightMoveDuration: 500
					highlight: Rectangle { 
						color: Theme.colors.backgroundHighlight;
						ColorBehavior on color {}
					}
					currentIndex: -1

					delegate: RowLayout {
						IconImage {
							implicitSize: 50
							source: Quickshell.iconPath(modelData.icon)
						}
						CustomText {
							text: modelData.name
						}
						function activate() {
							modelData.execute()
							root.visible = false
							searchBox.clear()
						}
						Keys.onPressed: (event) => {
							if (event.key === Qt.Key_Enter-1) {
								activate()
							}
						}
					}
					remove: Transition {
						NumberAnimation { properties: "x"; duration: 500; from: 0; to: 300; easing.type: Easing.InOutQuad }
						NumberAnimation { properties: "opacity"; duration: 400; from: 1; to: 0; easing.type: Easing.OutExpo }
					}
					add: Transition {
						NumberAnimation { properties: "x"; duration: 500; from: 260; to: 0; easing.type: Easing.OutExpo }
						NumberAnimation { properties: "opacity"; duration: 400; from: 0; to: 1; easing.type: Easing.OutExpo }
					}
					displaced: Transition {
						NumberAnimation { properties: "y"; duration: 200; easing.type: Easing.OutExpo }
					}
					Keys.onPressed: (event) => {
						if (event.key === Qt.Key_Up && currentIndex === 0) {
							searchBox.forceActiveFocus()
						}
					}
				}
			}
		}
	}
}
  
