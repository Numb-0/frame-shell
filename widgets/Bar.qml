import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

import "root:/widgets/bar/components"
import "root:/utils"
import "root:/config"

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar
      property var modelData
      screen: modelData
      color: Theme.colors.background
      // margins: 0
      property real padding: 6
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
