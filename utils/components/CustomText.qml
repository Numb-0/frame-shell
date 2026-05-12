import QtQuick
import qs.config
import qs.utils.behaviors

Text {
    color: Theme.colors.base06
    font.family: "JetBrains Mono"
    font.weight: Font.DemiBold
    font.hintingPreference: Font.PreferFullHinting
    font.pixelSize: 18
    renderType: Text.NativeRendering
    ColorBehavior on color {}
} 