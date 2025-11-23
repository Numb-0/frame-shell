import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth

import qs.services
import qs.config
import qs.utils

RowLayout {
    property string profile: PowerProfileService?.profile ?? "balanced"

    MaterialButton {
        id: profileButton
        enabled: PowerProfileService.canChange
        iconName: profile === "performance" ? "bolt" : profile === "balanced" ? "power" : "energy_savings_leaf"
        iconColor: Theme.colors.green
        iconSize: 25
        onClicked: {
            PowerProfileService.cycleProfile()
            wiggleAnimation.start()
        }
        Animations.WiggleAnimation {
            id: wiggleAnimation
            target: profileButton
        }
    }
    CustomText {
        text: profile.charAt(0).toUpperCase() + profile.slice(1)
    }
    Item { Layout.fillWidth: true }
}
