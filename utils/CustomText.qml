import QtQuick
import qs.config

Text {
    color: Theme.colors.foregroundBright
    font.family: "JetBrains Mono"
    font.weight: Font.Bold
    font.hintingPreference: Font.PreferFullHinting
    renderType: Text.NativeRendering
    ColorBehavior on color {}
} 