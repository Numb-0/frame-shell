import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

import qs.widgets.bar.sections
import qs.utils
import qs.config
import qs.widgets

Scope {
  id: root
  signal dashboardToggleRequested()
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: window
      property var modelData
      property real padding: Config.spacing
      screen: modelData
      color: "transparent"
      implicitHeight: row.implicitHeight + padding
      margins {
        left: padding
        right: padding
        top: padding
      }

      Rectangle {
        anchors.fill: parent
        color: Theme.colors.base01
        radius: Config.rounding
      }

      ColorBehavior on color {}

      anchors {
        top: true
        left: true
        right: true
      }

      RowLayout {
        id: row
        anchors.fill: parent
        uniformCellSizes: true

        
        LeftSection {}
        CenterSection {}
        RightSection {}
      }
    }
  }
}