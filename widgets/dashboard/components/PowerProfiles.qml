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
        materialIcon.size: pressed ? 32 : 25
        enabled: PowerProfileService.canChange
        implicitHeight: 33
        implicitWidth: 37
        
        Behavior on materialIcon.size {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutBack
                easing.overshoot: 1.2
            }
        }
        
        onClicked: PowerProfileService.cycleProfile()
        
        iconName: profile === "performance" ? "bolt" : profile === "balanced" ? "power" : "energy_savings_leaf"
        iconColor: Theme.colors.green
    }
    
    CustomText {
        text: profile.charAt(0).toUpperCase() + profile.slice(1)
    }
}
