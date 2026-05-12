pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: theme
    readonly property QtObject colors: QtObject {
        property string base00: theme.normalizeColor(paletteAdapter.base00) // Background
        property string base01: theme.normalizeColor(paletteAdapter.base01) // Surface / panels
        property string base02: theme.normalizeColor(paletteAdapter.base02) // Elevated surface / highlights
        property string base03: theme.normalizeColor(paletteAdapter.base03) // Borders / separators
        property string base04: theme.normalizeColor(paletteAdapter.base04) // Muted text / secondary accents
        property string base05: theme.normalizeColor(paletteAdapter.base05) // Foreground / primary text
        property string base06: theme.normalizeColor(paletteAdapter.base06) // Strong foreground / bright text
        property string base07: theme.normalizeColor(paletteAdapter.base07) // Background variant / bright surface
        property string base08: theme.normalizeColor(paletteAdapter.base08) // Error / destructive
        property string base09: theme.normalizeColor(paletteAdapter.base09) // Warning / orange accent
        property string base0A: theme.normalizeColor(paletteAdapter.base0A) // Attention / yellow accent
        property string base0B: theme.normalizeColor(paletteAdapter.base0B) // Success / green accent
        property string base0C: theme.normalizeColor(paletteAdapter.base0C) // Info / cyan accent
        property string base0D: theme.normalizeColor(paletteAdapter.base0D) // Primary / blue accent
        property string base0E: theme.normalizeColor(paletteAdapter.base0E) // Secondary / purple accent
        property string base0F: theme.normalizeColor(paletteAdapter.base0F) // Extra accent / brown tone
    }

    function normalizeColor(color) {
        if (typeof color !== "string" || color.length === 0) {
            return "#FF0000"
        }
        return color.startsWith("#") ? color : "#" + color
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
