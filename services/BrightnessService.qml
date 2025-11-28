pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Singleton {
    id: root
    property int brightness
    property int brightnessPercent
    property string device: ""
    property int maxBrightness: 255
    property int minBrightness: 1
    property bool updating: false

    FileView {
        id: backlightView
        path: device !== "" ? `/sys/class/backlight/${device}/brightness` : ""
        watchChanges: true
        onFileChanged: {
            if (!root.updating) {
                updateBrightness()
            }
        }
    }

    function updateBrightness() {
        getBrightnessProcess.running = true
    }

    function setBrightness(percent) {
        root.updating = true
        root.brightnessPercent = percent
        setBrightnessProcess.exec(["brightnessctl", "set", percent + "%"])
    }

    Process {
        id: getBrightnessProcess
        command: ["brightnessctl", "-m"]
        stdout: SplitParser {
            onRead: (line) => {
                line = line.trim()
                var parts = line.split(",")
                if (parts.length >= 5) {
                    root.device = parts[0]
                    root.brightness = parseInt(parts[2])
                    root.brightnessPercent = parseInt(parts[3].replace("%", ""))
                }
                root.updating = false
            }
        }
    }

    Process {
        id: setBrightnessProcess
        onExited: root.updating = false
    }

    Component.onCompleted: {
        updateBrightness()
    }
}