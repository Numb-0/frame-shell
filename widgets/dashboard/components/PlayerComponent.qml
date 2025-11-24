import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.config
import qs.utils

RowLayout {
    required property var modelData
    spacing: 10
    
    CustomText {
        text: modelData.trackTitle || "Unknown Title"
    }
}