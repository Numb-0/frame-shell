pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Singleton {
    id: root
    property var adapters: []
    property var connections: []
    property var defaultAdapter
    property var connectedNetwork
    property bool wifiState: false

    function updateNetworkStatus() {
        // console.log("Updating network status...")
        adaptersProcess.running = true
        connectionsProcess.running = true
        wifiStateProcess.running = true
    }

    Component.onCompleted: {
        updateNetworkStatus()
    }

    Timer {
        id: debounceTimer
        interval: 300
        onTriggered: {
            updateNetworkStatus();
        }
    }

    Process {
        id: wifiStateProcess
        command: ["bash", "-c", "nmcli r wifi"]
        stdout: SplitParser {
            onRead: (line) => {
                line = line.trim()
                if (line === "enabled") {
                    root.wifiState = true
                } else if (line === "disabled") {
                    root.wifiState = false
                }
            }
        }
    }

    Process {
        running: true
        command: ["bash", "-c", "nmcli m"]
        stdout: SplitParser {
            onRead: () => {
                debounceTimer.restart();
            }
        }
    }

    Process {
        id: adaptersProcess
        command: ["bash", "-c", "nmcli -t device status"]
        onExited: root.defaultAdapter = root.adapters.find(a => a.state === "connected" && a.type === "ethernet") || root.adapters.find(a => a.state === "connected" && a.type === "wifi")
        stdout: SplitParser {
            onRead: (line) => {
                line = line.trim()
                if (line === "") return

                var parts = line.split(':')
                if (parts.length >= 4) {
                    var adapter = {
                        name: parts[0],
                        type: parts[1],
                        state: parts[2],
                        connection: parts[3]
                    }
                    // Update existing or add new
                    var existingIndex = root.adapters.findIndex(a => a.name === adapter.name)
                    if (existingIndex >= 0) {
                        root.adapters[existingIndex] = adapter
                    } else {
                        root.adapters.push(adapter)
                    }
                }
            }
        }
    }


    Process {
        id: connectionsProcess
        command: ["bash", "-c", "nmcli -terse device wifi"]
        onExited: root.connectedNetwork = root.connections.find(c => c.isActive)
        stdout: SplitParser {
            onRead: (line) => {
                if (line.trim() === "") return;
                var parts = [];
                var currentPart = "";
                var escapeNext = false;
                
                for (var i = 0; i < line.length; i++) {
                    var c = line[i];
                    
                    if (escapeNext) {
                        currentPart += c;
                        escapeNext = false;
                    } else if (c === '\\') {
                        escapeNext = true;
                    } else if (c === ':' && !escapeNext) {
                        parts.push(currentPart);
                        currentPart = "";
                    } else {
                        currentPart += c;
                    }
                }
                parts.push(currentPart);
                
                if (parts.length < 9) {
                    console.log("Invalid line format:", line);
                    return;
                }
                
                var connection = {
                    isActive: parts[0] === '*',
                    bssid: parts[1],
                    ssid: parts[2],
                    mode: parts[3],
                    channel: parseInt(parts[4]),
                    bitrate: parts[5],
                    signal: parseInt(parts[6]),
                    bars: parts[7],
                    security: parts[8]
                };
                
                connection.bssid = connection.bssid.replace(/\\:/g, ":");

                var existingIndex = -1
                for (var i = 0; i < root.connections.length; i++) {
                    if (root.connections[i].bssid === connection.bssid) {
                        existingIndex = i
                        break
                    }
                }
                
                if (existingIndex >= 0) {
                    root.connections[existingIndex] = connection
                } else {
                    root.connections.push(connection)
                }
            }
        }
    }
}