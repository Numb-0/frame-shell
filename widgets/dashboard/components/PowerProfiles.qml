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
    property var profile: PowerProfileService?.profile
    property var powerprofiles: ["performance", "balanced", "power-saver"]
    MaterialButton {
        onClicked: PowerProfileService.setPowerProfile(powerprofiles[(powerprofiles.indexOf(profile) + 1) % powerprofiles.length])
        iconName: profile === "performance" ? "bolt" : profile === "balanced" ? "power" : "energy_savings_leaf"
        iconColor: Theme.colors.green
        // backgroundColor: Theme.colors.backgroundHighlight
    }
    CustomText {
        // color: Theme
        text: profile
    }
}
