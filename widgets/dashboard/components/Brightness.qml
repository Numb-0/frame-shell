import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.config
import qs.utils
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
        iconColor: Theme.colors.orange
        iconSize: 30
    }

    Slider {
        id: brightnessSlider
        Layout.fillWidth: true
        Layout.preferredHeight: 15
        from: 1
        to: 100
        stepSize: 1
        value: BrightnessService.brightnessPercent
        
        onMoved: {
            BrightnessService.setBrightness(Math.round(value))
        }

        background: Rectangle {
            color: Theme.colors.backgroundHighlight
            ColorBehavior on color {}
            radius: Config.rounding

            Rectangle {
                width: brightnessSlider.visualPosition * parent.width
                height: parent.height
                color: Theme.colors.orange
                ColorBehavior on color {}
                radius: Config.rounding
            }
        }

        handle: Rectangle {
            x: brightnessSlider.visualPosition * (brightnessSlider.implicitWidth - width)
            y: brightnessSlider.implicitHeight / 2 - height / 2
            color: Theme.colors.orange
            ColorBehavior on color {}
            radius: Config.rounding
        }
    }
    CustomText {
        text: BrightnessService.brightnessPercent + "%"
        Layout.rightMargin: 15
        Layout.leftMargin: 10
        color: Theme.colors.orange
    }
}