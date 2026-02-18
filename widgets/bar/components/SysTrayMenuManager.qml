pragma Singleton
import Quickshell

Singleton {
    id: sysTrayMenuManager
    property var menus: []
    property var activeMenu: null
    property var sysTrayMenuComponent: Qt.createComponent("SysTrayMenu.qml")

    function registerMenu(modelData) {
        if (menus.find(m => m.modelData.id === modelData.id)) {
            return menus.find(m => m.modelData.id === modelData.id)
        }
        
        let menu = sysTrayMenuComponent.createObject(sysTrayMenuManager, { modelData: modelData })
        menus.push(menu)
        return menu
    }

    function setActiveMenu(modelData) {
        activeMenu = modelData
        activeMenuChanged()
    }
}