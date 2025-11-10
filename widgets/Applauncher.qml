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
		exclusiveZone: 0
		implicitWidth: 340
		implicitHeight: 330
		anchors.bottom: true
		focusable: true
		// Click only when opened
		mask: Region { item: col }
		color: "transparent"
		// Wayland/Hyprland
		screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? null
		HyprlandFocusGrab {
			id: grab
			windows: [ window ]
			active: root.visible
		}

		Shape {
			id: shp
			property real margin: 0
			property real rounding: Config.rounding
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			anchors.margins: margin
			height: root.visible ? parent.height - margin * 2 : 0

			Behavior on height {
				NumberAnimation {
					duration: 500
					easing.type: Easing.OutBack
				}
			}
			
			ShapePath {
				fillColor: Theme.colors.backgroundAlt
				strokeWidth: 0
				startX: shp.rounding; startY: 0

				PathQuad { x: 0; y: shp.rounding; controlX: 0; controlY: 0 }
				PathLine { x: 0; y: shp.height }
				PathLine { x: shp.width + shp.rounding; y: shp.height + shp.margin }
				PathLine { x: shp.width; y: shp.rounding }
				PathQuad { x: shp.width - shp.rounding; y: 0; controlX: shp.width; controlY: 0 }
				PathLine { x: shp.rounding; y: 0 }
			}
		}

		ColumnLayout {
			id: col
			anchors.fill: shp
			anchors.margins: 10
			Keys.onEscapePressed: root.visible = false
			TextField {
				id: searchBox
				Layout.fillWidth: true
				implicitHeight: 40
				font.bold: true
				font.family: "JetBrains Mono"
				focus: true
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
					radius: Config.rounding
				}
				currentIndex: -1

				delegate: RowLayout {
					IconImage {
						implicitSize: 40
						source: Quickshell.iconPath(modelData.icon)
					}
					CustomText {
						text: modelData.name
					}
					function activate() {
						modelData.execute()
						root.visible = false
						searchBox.focus = true
					}
					Keys.onReturnPressed: activate()
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
						appsList.currentIndex = -1
					}
				}
			}
		}
	}
}
  
