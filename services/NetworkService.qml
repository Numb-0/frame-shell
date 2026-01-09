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
    property var savedConnections: []
    property var defaultAdapter
    property var connectedNetwork
    property bool wifiState: false
    property bool savedConnectionsLoaded: false
    property bool connectionsLoaded: false

    function updateNetworkStatus() {
        adaptersProcess.running = true
        connectionsProcess.running = true
        wifiStateProcess.running = true
    }

    function markSavedConnections() {
        if (!root.savedConnectionsLoaded || !root.connectionsLoaded) return
        
        var updatedConnections = []
        root.connections.forEach(conn => {
            var isSaved = root.savedConnections.some(saved => saved.name === conn.ssid)
            var updatedConn = {
                isActive: conn.isActive,
                bssid: conn.bssid,
                ssid: conn.ssid,
                mode: conn.mode,
                channel: conn.channel,
                bitrate: conn.bitrate,
                signal: conn.signal,
                bars: conn.bars,
                security: conn.security,
                saved: isSaved
            }
            updatedConnections.push(updatedConn)
        })
        updatedConnections.sort((a, b) => {
            if (a.isActive && !b.isActive) return -1
            if (!a.isActive && b.isActive) return 1
            if (a.saved && !b.saved) return -1
            if (!a.saved && b.saved) return 1
            return b.signal - a.signal
        })
        root.connections = updatedConnections
    }

    Component.onCompleted: {
        updateNetworkStatus()
    }

    Timer {
        id: debounceTimer
        interval: 500
        onTriggered: {
            updateNetworkStatus();
        }
    }

    Process {
        id: savedConnectionsProcess
        running: true
        command: ["bash", "-c", "nmcli -t connection show"]
        property var tempSavedConnections: []
        onStarted: tempSavedConnections = []
        onExited: {
            root.savedConnections = tempSavedConnections
            root.savedConnectionsLoaded = true
            root.markSavedConnections()
        }
        stdout: SplitParser {
            onRead: (line) => {
                line = line.trim()
                if (line === "" || line.startsWith("NAME")) return
                var parts = line.split(':')
                if (parts.length >= 4) {
                    var connection = {
                        name: parts[0],
                        uuid: parts[1],
                        type: parts[2],
                        device: parts[3] 
                    }
                    savedConnectionsProcess.tempSavedConnections.push(connection)
                }
            }
        }
    }

    function toggleWifi() {
        wifiToggleProcess.running = true
    }

    Process {
        id: wifiToggleProcess
        property var argument: root.wifiState ? "off" : "on"
        command: ["bash", "-c", "nmcli r wifi " + argument]
        onExited: root.updateNetworkStatus()
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

    function connect(ssid, password = "") {
        wifiConnectProcess.ssid = ssid
        console.log(ssid)
        wifiConnectProcess.password = password
        wifiConnectProcess.running = true
    }

    function disconnect() {
        wifiDisconnectProcess.running = true
    }

    Process {
        id: wifiDisconnectProcess
        property string adapter: root.defaultAdapter ? root.defaultAdapter.name : ""
        command: ["bash", "-c", "nmcli device disconnect " + adapter]
        onExited: root.updateNetworkStatus()
    }

    Process {
        property string ssid: ""
        property string password: ""
        id: wifiConnectProcess
        command: ["bash", "-c", "nmcli device wifi connect " + wifiConnectProcess.ssid + (wifiConnectProcess.password ? "" + wifiConnectProcess.password : "")]
        onExited: root.updateNetworkStatus()
    }

    Process {
        id: adaptersProcess
        command: ["bash", "-c", "nmcli -t device status"]
        onStarted: root.adapters = []
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
                        connection: parts[3],
                        saved: false
                    }
                    root.adapters.push(adapter)
                }
            }
        }
    }


    Process {
        id: connectionsProcess
        command: ["bash", "-c", "nmcli -terse device wifi"]
        property var tempConnections: []
        onStarted: tempConnections = []
        onExited: {
            root.connections = tempConnections
            root.connectedNetwork = root.connections.find(c => c.isActive)
            root.connectionsLoaded = true
            root.markSavedConnections()
        }
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
                    security: parts[8],
                    saved: false
                };
                
                connection.bssid = connection.bssid.replace(/\\:/g, ":");

                var existingIndex = -1
                for (var i = 0; i < connectionsProcess.tempConnections.length; i++) {
                    if (connectionsProcess.tempConnections[i].bssid === connection.bssid) {
                        existingIndex = i
                        break
                    }
                }
                
                if (existingIndex >= 0) {
                    connectionsProcess.tempConnections[existingIndex] = connection
                } else {
                    connectionsProcess.tempConnections.push(connection)
                }
            }
        }
    }
}