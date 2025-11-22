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
    // Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
    property string profile: PowerProfileService?.profile ?? "balanced"

    MaterialButton {
        id: profileButton
        enabled: PowerProfileService.canChange
        
        onClicked: PowerProfileService.cycleProfile()
        
        iconName: profile === "performance" ? "bolt" : profile === "balanced" ? "power" : "energy_savings_leaf"
        iconColor: Theme.colors.green
    }
    Item { Layout.fillWidth: true }
    CustomText {
        text: profile.charAt(0).toUpperCase() + profile.slice(1)
    }
    Item { Layout.fillWidth: true }
    Item { implicitWidth: profileButton.implicitWidth }
}
