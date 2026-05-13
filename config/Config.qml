pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: config
    property int rounding: 8
    property int spacing: 8
    FileView {
        path: Qt.resolvedUrl("./config.json")
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        printErrors: true
        JsonAdapter {
            property alias rounding: config.rounding
            property alias spacing: config.spacing
        }
        onLoadFailed: (error) => {
            if (error === FileViewError.FileNotFound) {
                writeAdapter()
            }
        }
    }
}
