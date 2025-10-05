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

    function updateNetworkStatus() {
        adaptersProcess.running = true
        connectionsProcess.running = true
    }

    Component.onCompleted: {
        updateNetworkStatus()
    }

    Process {
        id: eventProcess
        running: true
        command: ["bash", "-c", "nmcli m"]
        stdout: SplitParser {
            onRead: () => updateNetworkStatus()
        }
    }

    Process {
        id: adaptersProcess
        command: ["bash", "-c", "nmcli -terse device status"]
        onExited: () => root.defaultAdapter = root.adapters.find(a => a.isWifi) ?? null
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
                        connection: parts[3],
                        isWifi: parts[1] === "wifi",
                        isEthernet: parts[3].includes("Wired")
                    }
                    // console.log(adapter.name, adapter.state)
                    
                    var existingIndex = -1
                    for (var i = 0; i < root.adapters.length; i++) {
                        if (root.adapters[i].name === adapter.name) {
                            existingIndex = i
                            break
                        }
                    }
                    
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
        onExited: () => root.connectedNetwork = root.connections.find(c => c.isActive)
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