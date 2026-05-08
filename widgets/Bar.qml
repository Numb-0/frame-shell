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
        color: Theme.colors.backgroundAlt
        radius: Config.rounding
      }

      ColorBehavior on color {}

      anchors {
        top: true
        left: true
        right: true
      }
      
      MouseArea {
        anchors.fill: row
        hoverEnabled: true
        // onClicked: root.dashboardToggleRequested()
        propagateComposedEvents: true
        onClicked: console.log("Bar clicked")
      }

      MouseArea {
        anchors.fill: row
        hoverEnabled: true
        // preventStealing: true
        propagateComposedEvents: true
        onClicked: (mouse)=> {
                console.log("clicked blue")
                mouse.accepted = false
            }
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