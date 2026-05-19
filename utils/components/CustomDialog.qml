import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.config
import qs.utils.components

Dialog {
    id: root
    anchors.centerIn: parent
    implicitHeight: 200
    implicitWidth: 400
    modal: true
    required property string text

    background: Rectangle {
        color: Theme.colors.base01
        radius: Config.rounding
    }

    header: Rectangle {
        color: Theme.colors.base01
        radius: Config.rounding
        implicitHeight: 56
        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            CustomText {
                text: root.title
                color: Theme.colors.base05
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }
    }

    footer: Rectangle {
        color: Theme.colors.base01
        radius: Config.rounding
        implicitHeight: 56
        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10
            MaterialButton {
                iconName: "close"
                iconColor: Theme.colors.base05
                onClicked: root.reject()
            }
            Item { Layout.fillWidth: true }
            MaterialButton {
                iconName: "check"
                iconColor: Theme.colors.base08
                onClicked: root.accept()
            }
        }
    }

    contentItem: Item {
        implicitWidth: 400
        implicitHeight: 88
        CustomText {
            anchors.centerIn: parent
            width: parent.width - 32
            text: root.text
            color: Theme.colors.base05
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
        }
    }

    enter: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 250; easing.type: Easing.OutQuad }
            NumberAnimation { property: "scale"; from: 0.6; to: 1; duration: 250; easing.type: Easing.OutQuad }
        }
    }

    exit: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 250; easing.type: Easing.OutQuad }
            NumberAnimation { property: "scale"; from: 1; to: 0.6; duration: 250; easing.type: Easing.OutQuad }
        }
    }
}
