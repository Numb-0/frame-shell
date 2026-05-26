import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.config

Slider {
    id: root
    property color accentColor: Theme.colors.base0B
    property color trackColor: Theme.colors.base02
    property color disabledColor: Theme.colors.base05

    Layout.preferredHeight: 15

    background: Rectangle {
        color: root.trackColor
        radius: Config.rounding

        Rectangle {
            width: root.visualPosition * parent.width
            height: parent.height
            color: root.enabled ? root.accentColor : root.disabledColor
            opacity: root.enabled ? 1.0 : 0.3
            radius: Config.rounding

            Behavior on width {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    handle: Rectangle {
        x: root.visualPosition * (root.implicitWidth - width)
        y: root.implicitHeight / 2 - height / 2
        color: root.enabled ? root.accentColor : root.disabledColor
        opacity: root.enabled ? 1.0 : 0.5
        radius: Config.rounding
    }
}
