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
    property var wifiIcons: ({
        none: "network-wireless-signal-none",
        weak: "network-wireless-signal-weak",
        ok: "network-wireless-signal-ok",
        good: "network-wireless-signal-good",
        excellent: "network-wireless-signal-excellent",
    })

    function getWifiIcon(signal) {
        if (signal <= 10) return wifiIcons.none
        if (signal <= 30) return wifiIcons.weak
        if (signal <= 50) return wifiIcons.ok
        if (signal <= 75) return wifiIcons.good
        return wifiIcons.excellent
    }

    property var adapter: WifiService?.defaultAdapter
    property var connectedNet: WifiService?.connectedNetwork
    CustomText {
        text: connectedNet?.ssid ?? "No Network"
        color: Theme.colors.purple
    }
    IconButton {
        iconSource: Quickshell.iconPath(getWifiIcon(connectedNet?.signal))
        iconColor: Theme.colors.purple
    }
}
