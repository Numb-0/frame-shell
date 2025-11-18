import QtQuick
import qs.config

Text {
    color: Theme.colors.foregroundBright
    font.family: "JetBrains Mono"
    font.weight: Font.DemiBold
    font.hintingPreference: Font.PreferFullHinting
    font.pixelSize: 18
    renderType: Text.NativeRendering
    ColorBehavior on color {}
} 