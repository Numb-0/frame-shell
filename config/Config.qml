pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property string theme: "gruvbox"

    FileView {
        path: Qt.resolvedUrl("./config.json")
        //watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        printErrors: true
        // blockLoading: true

        JsonAdapter {
            property string themeConfig: theme
            onThemeConfigChanged: {
                // console.log(theme)
                theme = themeConfig
            }
        }
    }
}
