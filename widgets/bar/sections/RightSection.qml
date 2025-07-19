import QtQuick
import QtQuick.Layouts
import "root:/widgets/bar/components"

RowLayout {
    Layout.alignment: Qt.AlignRight
    Layout.rightMargin: 10
    spacing: 10
    
    Network {}
    Battery {}
    Volume {}
    SysTray {}
} 