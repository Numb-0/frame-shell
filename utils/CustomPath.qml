import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes
import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth

import qs.config
import qs.utils

Shape { 
    anchors.fill: parent
    property var wrapper: parent
    readonly property int rounding: Config.rounding
    property alias fillColor: shapePath.fillColor
    readonly property bool flatten: wrapper.height < rounding * 2
    readonly property real roundingY: flatten ? wrapper.height / 2 : rounding
    ShapePath {
        id: shapePath
        fillColor: Theme.colors.yellow
        capStyle: ShapePath.RoundCap
        strokeColor: Theme.colors.red
        strokeWidth: 2
        property int size: 100
        property int joinStyleIndex: 1
        // onClicked: joinStyleIndex = (joinStyleIndex + 1) % styles.length

        property variant styles: [
            ShapePath.BevelJoin,
            ShapePath.MiterJoin,
            ShapePath.RoundJoin
        ]

        joinStyle: styles[joinStyleIndex]
        startX: 0
        startY: -10

        PathLine { 
            relativeX: -(window.width + rounding); 
            relativeY: 0 
        }
        PathArc {
            relativeX: rounding
            relativeY: -roundingY
            radiusX: rounding
            radiusY: Math.min(rounding, wrapper.height)
            direction: PathArc.Counterclockwise
        }
        PathLine {
            relativeX: 0
            relativeY: -(wrapper.height - roundingY * 2)
        }
        PathArc {
            relativeX: rounding
            relativeY: -roundingY
            radiusX: rounding
            radiusY: Math.min(rounding, wrapper.height)
        }
        PathLine {
            relativeX: wrapper.height > 0 ? wrapper.width - rounding - rounding : wrapper.width
            relativeY: 0
        }
        PathArc {
            relativeX: rounding
            relativeY: -rounding
            radiusX: rounding
            radiusY: rounding
            direction: PathArc.Counterclockwise
        }
    }
}