import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.config
import qs.utils

Scope {
	id: root
	property bool visible: false
	property string searchText: ""

	GlobalShortcut {
		name: "applauncher"
		onPressed: root.visible = !root.visible
	}

	PanelWindow {
		id: window
		screen: Quickshell.screens.find(screen => Hyprland.monitorFor(screen) === Hyprland.focusedMonitor) ?? null
		visible: root.visible
		exclusiveZone: 0
		anchors.bottom: true
		
		implicitWidth: col.implicitWidth + Config.spacing * 2
		implicitHeight: col.implicitHeight + Config.spacing * 2
		focusable: root.visible
		mask: Region { item: background }
		color: "transparent"
		
		margins.bottom: Config.spacing

		Rectangle {
			id: background
			anchors.fill: parent
			color: Theme.colors.backgroundAlt
			radius: Config.rounding * 2
		}

		HyprlandFocusGrab {
			id: grab
			windows: [ window ]
			active: root.visible
		}

		ColumnLayout {
			id: col
			property int preferredWidth: 350
			anchors.centerIn: background
			spacing: Config.spacing
			Keys.onEscapePressed: root.visible = false

			TextField {
				id: searchBox
				implicitHeight: 30
				implicitWidth: col.preferredWidth
				font.bold: true
				font.family: "JetBrains Mono"
				focus: root.visible
				color: Theme.colors.foreground
				background: Rectangle {
					radius: Config.rounding
					color: Theme.colors.backgroundHighlight
					ColorBehavior on color {}
				}
				onTextChanged: {
					root.searchText = text
					appsList.currentIndex = -1
				}
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
					values: DesktopEntries.applications.values
					.filter(entry => entry.name.toLowerCase()
					.includes(root.searchText.toLowerCase()))
				}
				snapMode: ListView.SnapToItem
				implicitHeight: 200 // 40 * 5
				Layout.fillWidth: true
				clip: true
				highlightMoveDuration: 500
				highlight: Rectangle {
					width: appsList.width
					color: Theme.colors.backgroundHighlight
					ColorBehavior on color {}
					radius: Config.rounding
				}
				currentIndex: -1
				
				delegate: RowLayout {
					implicitHeight: 40
					implicitWidth: appsList.width
					spacing: 10
					IconImage {
						implicitSize: 40
						source: Quickshell.iconPath(modelData.icon == "" ? "application-x-executable" : modelData.icon)
					}
					CustomText { text: modelData.name }
					Item { Layout.fillWidth: true }
					function activate() {
						modelData.execute()
						root.visible = false
						appsList.currentIndex = -1
						appsList.positionViewAtBeginning()
						searchBox.focus = true
						searchBox.clear()
					}
					Keys.onReturnPressed: activate()
				}
				remove: Transition {
					ParallelAnimation {
						NumberAnimation { properties: "x"; duration: 600; from: 0; to: 300; easing.type: Easing.InOutQuad }
						NumberAnimation { properties: "opacity"; duration: 400; from: 1; to: 0; easing.type: Easing.OutExpo }
					}
				}
				add: Transition {
					ParallelAnimation {
						NumberAnimation { properties: "x"; duration: 600; from: 260; to: 0; easing.type: Easing.OutExpo }
						NumberAnimation { properties: "opacity"; duration: 400; from: 0; to: 1; easing.type: Easing.OutExpo }
					}
				}
				displaced: Transition {
					NumberAnimation { properties: "y"; duration: 300; easing.type: Easing.OutExpo }
				}
				Keys.onPressed: (event) => {
					if (event.key === Qt.Key_Up && currentIndex === 0) {
						searchBox.forceActiveFocus()
						appsList.currentIndex = -1
					}
				}
				Component.onDestruction: {
					appsList.model = null
				}
			}
		}
	}
}
  
