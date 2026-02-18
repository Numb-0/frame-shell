pragma Singleton
import Quickshell

Singleton {
    id: sysTrayMenuManager
    property var menus: []
    property var activeMenu: null

    function registerMenu(modelData) {
        if (menus.find(m => m.modelData.id === modelData.id)) {
            return menus.find(m => m.modelData.id === modelData.id)
        }
        
        let component = Qt.createComponent("SysTrayMenu.qml")
        if (component) {
            let menu = component.createObject(sysTrayMenuManager, { modelData: modelData })
            if (menu !== null) {
                menus.push(menu)
                return menu
            } else {
                console.error("Failed to create SysTrayMenu object")
            }
        } else if (component.status === Component.Error) {
            console.error("Error loading SysTrayMenu:", component.errorString())
        }
        
        return null
    }

    function setActiveMenu(modelData) {
        activeMenu = modelData
        activeMenuChanged()
    }
}