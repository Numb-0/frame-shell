import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import qs.config
import qs.utils.components

MouseArea {
	id: root

	required property var modelData
	property int iconSize: 40

	signal activated()

	implicitHeight: iconSize
	hoverEnabled: true
	cursorShape: Qt.PointingHandCursor

	onClicked: root.activated()
  Keys.onReturnPressed: root.activated()
  Component.onCompleted: console.log(modelData.icon)

	RowLayout {
		anchors.fill: parent
		spacing: 10

		IconImage {
			implicitSize: root.iconSize
			source: Quickshell.iconPath(root.modelData.icon || "application-x-executable")
		}

		CustomText {
			Layout.fillWidth: true
			text: root.modelData.name
			elide: Text.ElideRight
		}
  }
}
