pragma Singleton
import Quickshell

Singleton {
    id: sysTrayMenuManager
    property var activeMenu: null

    function setActiveMenu(modelData) {
        activeMenu = modelData
        activeMenuChanged()
    }
}