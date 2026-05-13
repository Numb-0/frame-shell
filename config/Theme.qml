pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: theme
    readonly property QtObject defaultTheme: QtObject {
        property string base00: "#1e1e1e" // Background
        property string base01: "#2d2d2d" // Surface / panels
        property string base02: "#3d3d3d" // Elevated surface / highlights
        property string base03: "#4d4d4d" // Borders / separators
        property string base04: "#8b8b8b" // Muted text / secondary accents
        property string base05: "#d4d4d4" // Foreground / primary text
        property string base06: "#efefef" // Strong foreground / bright text
        property string base07: "#f5f5f5" // Background variant / bright surface
        property string base08: "#f48771" // Error / destructive
        property string base09: "#f5a891" // Warning / orange accent
        property string base0A: "#ffd57f" // Attention / yellow accent
        property string base0B: "#80c985" // Success / green accent
        property string base0C: "#7bd3f0" // Info / cyan accent
        property string base0D: "#82b1ff" // Primary / blue accent
        property string base0E: "#c792ea" // Secondary / purple accent
        property string base0F: "#c4a87e" // Extra accent / brown tone
    }

    readonly property QtObject colors: QtObject {
        property string base00: theme.normalizeColor(paletteAdapter.base00 || defaultTheme.base00)
        property string base01: theme.normalizeColor(paletteAdapter.base01 || defaultTheme.base01)
        property string base02: theme.normalizeColor(paletteAdapter.base02 || defaultTheme.base02)
        property string base03: theme.normalizeColor(paletteAdapter.base03 || defaultTheme.base03)
        property string base04: theme.normalizeColor(paletteAdapter.base04 || defaultTheme.base04)
        property string base05: theme.normalizeColor(paletteAdapter.base05 || defaultTheme.base05)
        property string base06: theme.normalizeColor(paletteAdapter.base06 || defaultTheme.base06)
        property string base07: theme.normalizeColor(paletteAdapter.base07 || defaultTheme.base07)
        property string base08: theme.normalizeColor(paletteAdapter.base08 || defaultTheme.base08)
        property string base09: theme.normalizeColor(paletteAdapter.base09 || defaultTheme.base09)
        property string base0A: theme.normalizeColor(paletteAdapter.base0A || defaultTheme.base0A)
        property string base0B: theme.normalizeColor(paletteAdapter.base0B || defaultTheme.base0B)
        property string base0C: theme.normalizeColor(paletteAdapter.base0C || defaultTheme.base0C)
        property string base0D: theme.normalizeColor(paletteAdapter.base0D || defaultTheme.base0D)
        property string base0E: theme.normalizeColor(paletteAdapter.base0E || defaultTheme.base0E)
        property string base0F: theme.normalizeColor(paletteAdapter.base0F || defaultTheme.base0F)
    }

    function normalizeColor(color) {
        if (!color || (typeof color === "string" && color.length === 0)) {
            return color
        }
        return typeof color === "string" && color.startsWith("#") ? color : "#" + color
    }

    FileView {
        id: file
        path: ".config/stylix/palette.json"
        watchChanges: true
        printErrors: true
        JsonAdapter {
            id: paletteAdapter
            property string base00
            property string base01
            property string base02
            property string base03
            property string base04
            property string base05
            property string base06
            property string base07
            property string base08
            property string base09
            property string base0A
            property string base0B
            property string base0C
            property string base0D
            property string base0E
            property string base0F
        }
    }
}
