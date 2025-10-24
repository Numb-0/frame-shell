import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

import "root:/widgets/bar/sections"
import "root:/utils"
import "root:/config"

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar
      property var modelData
      property real padding: 4
      screen: modelData
      color: Theme.colors.background
      // surfaceFormat: [true]
      implicitHeight: barrow.implicitHeight + padding * 2
      

      ColorBehavior on color {}

      anchors {
        top: true
        left: true
        right: true
      }

      RowLayout {
        id: barrow
        anchors.fill: parent
        uniformCellSizes: true
        
        LeftSection {}
        CenterSection {}
        RightSection {}
      }
    }
  }
}
