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
        none: "network-wireless-signal-none",
        weak: "network-wireless-signal-weak",
        ok: "network-wireless-signal-ok",
        good: "network-wireless-signal-good",
        excellent: "network-wireless-signal-excellent",
    })

    function getNetworkIcon(signal) {
        if (signal <= 10) return networkIcons.none
        if (signal <= 30) return networkIcons.weak
        if (signal <= 50) return networkIcons.ok
        if (signal <= 75) return networkIcons.good
        return networkIcons.excellent
    }

    property var adapter: NetworkService?.defaultAdapter
    property var connectedNet: NetworkService?.connectedNetwork
    CustomText {
        text: connectedNet?.ssid ?? "No Network"
        color: Theme.colors.purple
    }
    IconButton {
        iconSource: Quickshell.iconPath(getNetworkIcon(connectedNet?.signal))
        iconColor: Theme.colors.purple
    }
}
