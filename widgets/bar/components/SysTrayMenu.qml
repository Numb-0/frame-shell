pragma Singleton
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

Singleton {
	id: root
	property bool visible: false
    property var modelData

    function toggle(modelData) {
        if(root.modelData != modelData && modelData != null) {
            root.visible = false
            root.modelData = modelData
            switchTimer.start()
        }
        root.visible = !root.visible
    }

    Timer {
		id: switchTimer
		interval: 200
		onTriggered: root.visible = true
	}

    LazyLoader {
		active: root.visible

        PanelWindow {
            id: window
            screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? null
            exclusiveZone: 0
            color: "transparent"
            visible: root.visible
            implicitWidth: 200
            // WlrLayershell.layer: WlrLayer.Overlay
            // WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            mask: Region {
                item: actionList
            }

            anchors {
                top: true            
                right: true
                bottom: true
            }

            QsMenuOpener {
                id: opener
                menu: modelData?.menu
            }

            ColumnLayout {
                id: actionList
                anchors.right: parent.right
                // Keys.onEscapePressed: { root.visible = false }

                Repeater {
                    model: ScriptModel {
                        values: opener.children.values.filter(m => m.text != "")
                    }
                    delegate: Button {
                        Layout.alignment: Qt.AlignRight | Qt.AlignTop
                        onClicked: {
                            root.visible = false
                            modelData.triggered()
                        }
                        contentItem: CustomText {
                            text: modelData.text
                        }
                        background: Rectangle {
                            color: parent.hovered ? Theme.colors.backgroundHighlight : Theme.colors.background
                            ColorBehavior on color { duration: 200 }
                        }
                    }
                }
            }  
        }
    }
}