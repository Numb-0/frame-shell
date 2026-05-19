import QtQuick

import qs.config

MaterialButton {
    id: root
    required property bool expanded
    
    iconName: "keyboard_arrow_right"
    iconColor: Theme.colors.base05
    iconSize: 30
    iconPadding: 5

    onExpandedChanged: rotateAnim.start()

    RotationAnimation {
        id: rotateAnim
        target: root
        from: !root.expanded ? 0 : 90
        to: !root.expanded ? 90 : 0
        duration: 300
        easing.type: Easing.OutExpo
    }
}
