import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.config
import qs.utils.behaviors
import qs.utils.components
import qs.services


RowLayout {
    Layout.fillWidth: true
    spacing: 0
    
    property var brightnessIcons: ({
        low: "brightness_3",
        medium: "brightness_5",
        high: "brightness_7"
    })

    function getBrightnessIcon() {
        const percent = BrightnessService.brightnessPercent
        if (percent <= 33) return brightnessIcons.low
        if (percent <= 66) return brightnessIcons.medium
        return brightnessIcons.high
    }

    MaterialButton {
        iconName: getBrightnessIcon()
        iconColor: Theme.colors.base09
        iconSize: 30
        iconPadding: 5
    }

    ThemedSlider {
        Layout.fillWidth: true
        from: 1
        to: 100
        stepSize: 1
        value: BrightnessService.brightnessPercent
        accentColor: Theme.colors.base09

        onMoved: BrightnessService.setBrightness(Math.round(value))
    }
    CustomText {
        text: BrightnessService.brightnessPercent + "%"
        Layout.rightMargin: 15
        Layout.leftMargin: 10
        color: Theme.colors.base09
    }
}