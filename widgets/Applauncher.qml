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
		anchors {
			bottom: true
			top: true
		}
		implicitWidth: shp.implicitWidth
		focusable: true
		mask: Region { item: shp }
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
			property real padding: Config.rounding * 3
			anchors.bottom: parent.bottom
			width: col.implicitWidth + Config.rounding * 6

			states: [
				State {
					name: "hidden"
					when: !root.visible
					PropertyChanges { target: shp; height: 0; rounding: 0}
				},
				State {
					name: "visible"
					when: root.visible
					PropertyChanges { target: shp; height: col.implicitHeight + Config.rounding * 2; rounding: Config.rounding * 2 }
				}
			]

			transitions: [
				Transition {
					from: "hidden"; to: "visible"
					NumberAnimation { properties: "height"; duration: 500; easing.type: Easing.OutBack }
					NumberAnimation {
                            properties: "rounding"
                            duration: 400
                            easing.type: Easing.OutBack
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
				PathLine { x: shp.width; y: shp.height }
				// Bottom-right corner
				PathQuad { x: shp.width - shp.rounding; y: shp.height - shp.rounding; controlX: shp.width - shp.rounding; controlY: shp.height }
				PathLine { x: shp.width - shp.rounding; y: shp.rounding }
				// Top-right corner
				PathQuad { x: shp.width - shp.rounding * 2; y: 0; controlX: shp.width - shp.rounding; controlY: 0 }
				PathLine { x: shp.rounding * 2; y: 0 }
				// Top-left corner
				PathQuad { x: shp.rounding; y: shp.rounding; controlX: shp.rounding; controlY: 0 }
				PathLine { x: shp.rounding; y: shp.height - shp.rounding }
				// Bottom-left corner
				PathQuad { x: 0; y: shp.height; controlX: shp.rounding; controlY: shp.height }
			}
		}

		ColumnLayout {
			id: col
			property int minimumWidth: 350
			anchors.top: shp.top
            anchors.left: shp.left
            anchors.right: shp.right
            anchors.leftMargin: shp.padding
            anchors.rightMargin: shp.padding
			anchors.topMargin: shp.padding / 2
			Keys.onEscapePressed: root.visible = false

			TextField {
				id: searchBox
				implicitHeight: 40
				implicitWidth: col.minimumWidth
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
				implicitHeight: contentHeight * 5 / count // Show up to 5 items without scrolling
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
						source: Quickshell.iconPath(modelData.icon)
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
  
