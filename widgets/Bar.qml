import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

import qs.widgets.bar.sections
import qs.utils
import qs.config

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar
      property var modelData
      property real padding: Config.spacing
      screen: modelData
      color: "transparent"
      implicitHeight: barrow.implicitHeight + padding * 2
      margins {
        left: padding
        right: padding
        top: padding
      }

      Rectangle {
        anchors.fill: parent
        color: Theme.colors.backgroundAlt
        radius: Config.rounding * 2
      }

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
