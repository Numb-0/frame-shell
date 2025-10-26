import QtQuick
import qs.config

Text {
    color: Theme.colors.foregroundBright
    font.family: "JetBrains Mono"
    // font.semibold: true
    // font.hintingPreference: Font.PreferFullHinting
    font.hintingPreference: Font.PreferNoHinting
    font.pixelSize: 18
    renderType: Text.NativeRendering
    ColorBehavior on color {}
} 