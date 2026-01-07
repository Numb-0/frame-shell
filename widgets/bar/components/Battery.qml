import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower

import qs.config
import qs.utils

RowLayout {
    id: root
    property var battery: UPower.displayDevice
    
    property var batteryIcons: ({
        charging: {
            full: "battery_charging_Full",
            high: "battery_charging_90",
            medium: "battery_charging_80",
            mediumLow: "battery_charging_60",
            low: "battery_charging_50",
            veryLow: "battery_charging_30",
            critical: "battery_charging_20"
        },
        discharging: {
            full: "battery_full",
            high: "battery_6_bar",
            medium: "battery_5_bar",
            mediumLow: "battery_4_bar",
            low: "battery_3_bar",
            veryLow: "battery_2_bar",
            critical: "battery_1_bar"
        }
    })

    function getBatteryIcon() {
        const percentage = battery?.percentage ?? 0
        const isCharging = battery?.state == UPowerDeviceState.Charging
        const iconSet = isCharging ? batteryIcons.charging : batteryIcons.discharging
        
        if (percentage >= 0.9) return iconSet.full
        if (percentage >= 0.8) return iconSet.high
        if (percentage >= 0.6) return iconSet.medium
        if (percentage >= 0.5) return iconSet.mediumLow
        if (percentage >= 0.3) return iconSet.low
        if (percentage >= 0.2) return iconSet.veryLow
        return iconSet.critical
    }
    
    ProgressBar {
        id: progress
        Layout.preferredWidth: 80
        Layout.preferredHeight: 15
        value: battery.percentage
        from: 0
        to: 1

        background: Rectangle {
            color: Theme.colors.backgroundHighlight
            ColorBehavior on color {}
            border.width: 0
            radius: Config.rounding
        }

        contentItem: Item {
            Rectangle {
                width: parent.width * parent.parent.visualPosition
                height: parent.height
                color: progress.value < 0.3 ? Theme.colors.red : Theme.colors.yellow
                ColorBehavior on color {}
                radius: Config.rounding
            }
        }
    }

    CustomText {
        id: percentageText
        property bool show: false
        text: Math.round(battery.percentage * 100) + '%'
        color: Theme.colors.yellow
        opacity: show ? 1 : 0
        Layout.preferredWidth: show ? implicitWidth : 0
        Behavior on Layout.preferredWidth { 
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic } 
        }
        Behavior on opacity { 
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic } 
        }
    }

    MaterialButton {
        onHoveredChanged: percentageText.show = hovered
        iconName: getBatteryIcon()
        iconColor: progress.value < 0.3 ? Theme.colors.red : Theme.colors.yellow
    }
}
