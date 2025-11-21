import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland

import qs.config
import qs.utils
import qs.widgets.dashboard.components

Scope {
    Variants {
    model: Quickshell.screens

    PanelWindow {
      id: window
      property var modelData
      screen: modelData
      color: "transparent"
      implicitHeight: corners.rounding
      exclusiveZone: 0
      mask: Region {}
      ColorBehavior on color {}

      anchors {
        top: true
        left: true
        right: true
      }
      
      Shape {
        id: corners
        property int rounding: 16
        ShapePath {
            strokeWidth: 0
            fillColor: Theme.colors.backgroundAlt
            startX: 0
            startY: 0
            PathLine { x: corners.rounding; y: 0 }
            PathQuad { x: 0; y: corners.rounding; controlX: 0; controlY: 0 }
            PathLine { x: 0; y: 0 }
        }

        ShapePath {
            strokeWidth: 0
            fillColor: Theme.colors.backgroundAlt
            startX: 0
            startY: 0
            PathLine { x: window.width - corners.rounding; y: 0 }
            PathQuad { x: window.width; y: corners.rounding; controlX: window.width; controlY: 0 }
            PathLine { x: window.width; y: 0 }
        }
      }
    }
  }
}