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

    function updateWifiStatus() {
        getWifiStatus.running = true
        getConnections.running = true
    }

    Component.onCompleted: {
        updateWifiStatus()
    }

    property var wifiIcons: ({
        none: "network-wireless-signal-none",
        weak: "network-wireless-signal-weak",
        weak: "network-wireless-signal-ok",
        weak: "network-wireless-signal-good",
        weak: "network-wireless-signal-excellent",

    })

    function getVolumeIcon(signal) {
        if (signal <= 10) return wifiIcons.none
        if (signal <= 30) return wifiIcons.weak
        if (volume <= 50) return wifiIcons.ok
        if (volume <= 75) return wifiIcons.good
        return wifiIcons.excellent
    }

    Process {
        id: getWifiStatus
        command: ["bash", "-c", "nmcli -terse device status"]
        onExited: () => root.defaultAdapter = adapters[0] ?? null
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
                        isConnected: parts[2].includes("connected"),
                        isEthernet: parts[1] === "ethernet"
                    }
                    
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
                    // console.log(adapter.connection)
                }
            }
        }
    }

    Process {
        id: getConnections
        command: ["bash", "-c", "nmcli -terse device wifi"]
        onExited: () => root.connectedNetwork = root.connections.find(c => c.isActive)
        stdout: SplitParser {
            onRead: (line) => {
                if (line.trim() === "") return;
                
                // First split on unescaped colons only
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
                parts.push(currentPart); // Add the last part
                
                // We need at least 9 parts (some security fields might be empty)
                if (parts.length < 9) {
                    console.log("Invalid line format:", line);
                    return;
                }
                
                // Create the connection object
                var connection = {
                    isActive: parts[0] === '*', // '*' means currently connected
                    bssid: parts[1], // MAC address (BSSID) with escaped colons
                    ssid: parts[2], // WiFi name
                    mode: parts[3], // "Infra" (managed) or "Ad-hoc"
                    channel: parseInt(parts[4]), // Channel number
                    bitrate: parts[5], // Speed (e.g., "130 Mbit/s")
                    signal: parseInt(parts[6]), // Signal strength (0-100)
                    bars: parts[7], // Visual signal strength (e.g., "▂▄▆_")
                    security: parts[8] // Security type (e.g., "WPA2")
                };
                
                // Convert escaped colons in MAC address to regular colons
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

                console.log(root.connections.find(c => c.isActive)?.ssid ?? "No active connection")
                
                // console.log("Parsed connection:", JSON.stringify(connection, null, 2));
                
                // You can now use the connection object as needed
                // wifiModel.append(connection);
            }
        }
    }
}