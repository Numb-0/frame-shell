pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: config
    property string theme: "gruvbox"
    property int rounding: 8
    FileView {
        path: Qt.resolvedUrl("./config.json")
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        printErrors: true
        // blockLoading: true

        JsonAdapter {
            property alias theme: config.theme
            property alias rounding: config.rounding
        }
    }
}
