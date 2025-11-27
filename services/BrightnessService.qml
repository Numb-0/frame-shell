pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Singleton {
    id: root
    property int brightness: 0
    property int brightnessPercent: 0
    property int maxBrightness: 255
    property int minBrightness: 1

    FileView {
        id: backlightView
        path: "/sys/class/backlight/"
        watchChanges: true
        onFileChanged: {
            updateBrightness()
        }
    }

    function updateBrightness() {
        getBrightnessProcess.running = true
    }

    Process {
        id: getBrightnessProcess
        command: ["bash", "-c", "brightnessctl -m"]
        stdout: SplitParser {
            onRead: (line) => {
                line = line.trim()
                var parts = line.split(",")
                if (parts.length >= 5) {
                    root.brightness = parseInt(parts[2])
                    root.brightnessPercent = parseInt(parts[3].replace("%", ""))
                }
            }
        }
    }

    Process {
        id: setBrightnessProcess
        command: ["bash", "-c", "brightnessctl set " + root.brightnessPercent + "%"]
    }

    Component.onCompleted: {
        updateBrightness()
    }
}