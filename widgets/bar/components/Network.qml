import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Networking

import qs.utils
import qs.config
import qs.services

RowLayout {
    id: root
    property var networkIcons: ({
        none: "wifi_off",
        weak: "wifi_1_bar",
        ok: "wifi_2_bar",
        good: "wifi",
        excellent: "wifi",
        ethernet: "lan"
    })

    function getNetworkIcon(signal) {
        if (signal == -1) return networkIcons.ethernet
        if (signal == 0) return networkIcons.none
        if (signal <= 0.2) return networkIcons.weak
        if (signal <= 0.5) return networkIcons.ok
        if (signal <= 0.75) return networkIcons.good
        return networkIcons.excellent
    }

    property var networking: Networking
    property var adapter: networking.devices.values.find(d => d.state === ConnectionState.Connected)
    property var connectedNet: adapter ? adapter.networks.values.find(n => n.connected) : null

    CustomText {
        text: connectedNet?.name ?? "No network"
        color: Theme.colors.purple
    }

    MaterialSymbol {
        size: 25
        icon: getNetworkIcon(connectedNet?.signalStrength)
        color: Theme.colors.purple
    }
}
