import QtQuick
import qs.config

Text {
    color: Theme.colors.foregroundBright
    font.family: "JetBrains Mono"
    // font.semibold: true
    // font.hintingPreference: Font.PreferFullHinting
    font.hintingPreference: Font.PreferDefaultHinting
    renderType: Text.NativeRendering
    ColorBehavior on color {}
} 