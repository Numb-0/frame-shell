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
    spacing: 10
    
    CustomText {
        text: BrightnessService.brightnessPercent + "%"
    }
}