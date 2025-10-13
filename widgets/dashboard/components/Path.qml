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
    width: 200
    height: 200
    ShapePath {
        id: shapePath
        fillColor: Theme.colors.yellow
        capStyle: ShapePath.RoundCap
        strokeColor: Theme.colors.green
        strokeWidth: 16
        property int joinStyleIndex: 1
        // onClicked: joinStyleIndex = (joinStyleIndex + 1) % styles.length

        property variant styles: [
            ShapePath.BevelJoin,
            ShapePath.MiterJoin,
            ShapePath.RoundJoin
        ]

        joinStyle: styles[joinStyleIndex]
        startX: 30
        startY: 30
        PathLine { x: 100; y: 100 }
        PathLine { x: 30; y: 100 }
    }
}