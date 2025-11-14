pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.widgets.notification.components

Singleton {
    id: root
    property var profile: null

    function updatePowerProfile() {
      getProfile.running = true
    }

    function setPowerProfile(newProfile) {
      root.profile = newProfile
      setProfile.running = true
    }

    Component.onCompleted: {
        updatePowerProfile()
    }

    Process {
        id: getProfile
        command: ["bash", "-c", "powerprofilesctl get"]
        stdout: SplitParser {
            onRead: (data) => {
              profile = data
            }
        }
    }

    Process {
      id: setProfile
      command: ["bash", "-c", "powerprofilesctl set " + root.profile]
      onExited: (exitCode) => {
        if (exitCode === 0)
          NotificationManager.sendNotification("Power Profile Changed", "Power profile set to " + root.profile)
        else
          NotificationManager.sendNotification("Power Profile Change Failed", "Failed to set power profile to " + root.profile)
        getProfile.running = true
      }
    }
}
