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
        weak: "wifi_1_bar",
        ok: "wifi_2_bar",
        good: "wifi",
        excellent: "wifi",
        ethernet: "lan"
    })

    function getNetworkIcon(signal) {
        if (signal == -1) return networkIcons.ethernet
        if (signal == undefined) return networkIcons.none
        if (signal <= 30) return networkIcons.weak
        if (signal <= 50) return networkIcons.ok
        if (signal <= 75) return networkIcons.good
        return networkIcons.excellent
    }

    property var adapter: NetworkService?.defaultAdapter
    property var connectedNet: NetworkService?.connectedNetwork
    
    CustomText {
        text: NetworkService.wifiState ? (connectedNet?.ssid ?? "No Network") : "Wifi Off"
        color: Theme.colors.purple
    }

    MaterialSymbol {
        size: 25
        icon: getNetworkIcon(adapter?.isEthernet ? -1 : connectedNet?.signal)
        color: Theme.colors.purple
    }
}
