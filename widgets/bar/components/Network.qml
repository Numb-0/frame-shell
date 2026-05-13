import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Networking

import qs.config
import qs.services
import qs.utils.components

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

    function getNetworkIcon(signal, ethernet = false) {
        if (ethernet) return networkIcons.ethernet
        if (signal == 0) return networkIcons.none
        if (signal <= 0.2) return networkIcons.weak
        if (signal <= 0.5) return networkIcons.ok
        if (signal <= 0.75) return networkIcons.good
        return networkIcons.excellent
    }

    property var networking: Networking
    property var adapter: networking.devices.values.find(d => d.state === ConnectionState.Connected)
    property var connectedNetwork: adapter?.networks?.values.find(n => n.connected)
    property bool isEthernet: connectedNetwork?.device.type == DeviceType.Wired

    CustomText {
        text: !isEthernet ? connectedNetwork?.name ?? "No network" : "Ethernet"
        color: Theme.colors.base0E
    }

    MaterialSymbol {
        size: 25
        icon: getNetworkIcon(connectedNetwork?.signalStrength, isEthernet)
        color: Theme.colors.base0E
    }
}
