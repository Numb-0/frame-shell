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
		implicitWidth: 380
		implicitHeight: 360
		anchors.bottom: true
		margins.top: 80
		focusable: true
		mask: Region { item: col }
		color: "transparent"
		screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? null

		HyprlandFocusGrab {
			id: grab
			windows: [ window ]
			active: root.visible
		}

		Shape {
			id: shp
			property real rounding: 0
			property real roundingMax: 10
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom

			states: [
				State {
					name: "hidden"
					when: !root.visible
					PropertyChanges { target: shp; height: 0; rounding: 0}
				},
				State {
					name: "visible"
					when: root.visible
					PropertyChanges { target: shp; height: parent.height; rounding: shp.roundingMax }
				}
			]

			transitions: [
				Transition {
					from: "hidden"; to: "visible"
					NumberAnimation { properties: "height"; duration: 500; easing.type: Easing.OutBack }
					NumberAnimation {
                            properties: "rounding"
                            duration: 400
                            easing.type: Easing.OutCubic
                        }
				},
				Transition {
					from: "visible"; to: "hidden"
					NumberAnimation { properties: "height"; duration: 400; easing.type: Easing.InBack }
					NumberAnimation {
                            properties: "rounding"
                            duration: 400
                            easing.type: Easing.InBack
                        }
				}
			]

			ShapePath {
				fillColor: Theme.colors.backgroundAlt
				strokeWidth: 0
				startX: 0; startY: shp.height
				PathQuad { x: shp.rounding; y: shp.height - shp.rounding; controlX: shp.rounding; controlY: shp.height }
				PathLine { x: shp.rounding; y: shp.rounding }
				PathQuad { x: shp.rounding * 2; y: 0; controlX: shp.rounding; controlY: 0 }
				PathLine { x: shp.width - shp.rounding * 2; y: 0 }
				PathQuad { x: shp.width - shp.rounding; y: shp.rounding; controlX: shp.width - shp.rounding; controlY: 0 }
				PathLine { x: shp.width - shp.rounding; y: shp.height - shp.rounding }
				PathQuad { x: shp.width; y: shp.height; controlX: shp.width - shp.rounding; controlY: shp.height }
			}
		}

		ColumnLayout {
			id: col
			anchors.fill: shp
			anchors.leftMargin: shp.rounding * 2
			anchors.rightMargin: shp.rounding * 2
			anchors.topMargin: shp.rounding
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
				implicitHeight: 270
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
					CustomText { text: modelData.name }
					function activate() {
						modelData.execute()
						root.visible = false
						searchBox.focus = true
					}
					Keys.onReturnPressed: activate()
				}
				remove: Transition {
					NumberAnimation { properties: "x"; duration: 600; from: 0; to: 300; easing.type: Easing.InOutQuad }
					NumberAnimation { properties: "opacity"; duration: 400; from: 1; to: 0; easing.type: Easing.OutExpo }
				}
				add: Transition {
					NumberAnimation { properties: "x"; duration: 600; from: 260; to: 0; easing.type: Easing.OutExpo }
					NumberAnimation { properties: "opacity"; duration: 400; from: 0; to: 1; easing.type: Easing.OutExpo }
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
			}
		}
	}
}
  
