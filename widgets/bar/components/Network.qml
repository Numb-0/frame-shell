import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets

import qs.utils
import qs.config
import qs.services

RowLayout {
    id: root
    property var networkIcons: ({
        none: "wifi_off",
        weak: "wifi_bar_1",
        ok: "wifi_bar_2",
        good: "wifi",
        excellent: "wifi",
        ethernet: "lan"
    })

    function getNetworkIcon(signal) {
        if (signal == undefined) return networkIcons.ethernet
        if (signal <= 10) return networkIcons.none
        if (signal <= 30) return networkIcons.weak
        if (signal <= 50) return networkIcons.ok
        if (signal <= 75) return networkIcons.good
        return networkIcons.excellent
    }

    property var adapter: NetworkService?.defaultAdapter
    property var connectedNet: NetworkService?.connectedNetwork
    
    CustomText {
        text: adapter?.state != "disconnected" ? adapter?.isEthernet ? "Ethernet" : (connectedNet?.ssid ?? "No Network") : "No Connection"
        color: Theme.colors.purple
    }

    MaterialSymbol {
        size: 25
        icon: adapter?.state != "disconnected" ? getNetworkIcon(adapter?.isEthernet ? undefined : connectedNet?.signal) : networkIcons.none
        color: Theme.colors.purple
    }
}
