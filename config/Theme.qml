pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property QtObject colors: themeColors[Config.theme]
    property var availableThemes: ["gruvbox", "catppuccin"]

    property QtObject themeColors: QtObject {
        property QtObject gruvbox: QtObject {
            property string background: "#282828"
            property string backgroundAlt: "#3c3836"
            property string backgroundHighlight: "#504945"
            property string foreground: "#d5c4a1"
            property string foregroundBright: "#fbf1c7"
            property string foregroundDim: "#bdae93"
            property string red: "#fb4934"
            property string orange: "#fe8019"
            property string yellow: "#fabd2f"
            property string green: "#b8bb26"
            property string cyan: "#8ec07c"
            property string blue: "#83a598"
            property string purple: "#d3869b"
            property string brown: "#d65d0e"
        }
        
        property QtObject catppuccin: QtObject {
            property string background: "#24273a"
            property string backgroundAlt: "#1e2030"
            property string backgroundHighlight: "#363a4f"
            property string foreground: "#cad3f5"
            property string foregroundBright: "#b7bdf8"
            property string foregroundDim: "#5b6078"
            property string red: "#ed8796"
            property string orange: "#f5a97f"
            property string yellow: "#eed49f"
            property string green: "#a6da95"
            property string cyan: "#8bd5ca"
            property string blue: "#8aadf4"
            property string purple: "#c6a0f6"
            property string pink: "#f0c6c6"
        }
    }

    function nextTheme() {
        Config.theme = availableThemes[(availableThemes.indexOf(Config.theme) + 1) % availableThemes.length]
    }
}
