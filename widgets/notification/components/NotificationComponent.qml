import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

import qs.utils
import qs.config

Rectangle {
    id: root
    required property var modelData
    required property int index

    property real dragX: 0
    property real dragY: 0
    property real targetScale: index === 0 ? 1.0 : Math.pow(0.94, index)
    property real targetY: index * Config.spacing
    property real targetOpacity: index === 0 ? 1.0 : Math.max(0, 0.8 * Math.pow(0.7, index - 1))
    z: -index
    y: targetY

    transform: Translate {
        x: root.dragX
        y: -root.y + root.dragY + root.targetY 
    }

    Behavior on scale {
        NumberAnimation {
            duration: 400
            easing.type: Easing.OutQuad
        }
    }
    Behavior on opacity {
        NumberAnimation {
            duration: 400
            easing.type: Easing.OutQuad
        }
    }
    Behavior on targetY {
        NumberAnimation {
            duration: 400
            easing.type: Easing.OutQuad
        }
    }

    opacity: targetOpacity
    scale: targetScale
    color: Theme.colors.backgroundAlt
    radius: Config.rounding

    implicitWidth: 600
    implicitHeight: 150
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top

    onIndexChanged: {
        if (root.index === 0) {
            timeoutPieAnimation.start();
        }
    }

    readonly property bool discardThreshold: Math.sqrt(dragX ** 2 + dragY ** 2) > 130

    onDiscardThresholdChanged: {
        if (discardThreshold) {
            wiggleAnimation.restart();
        } else {
            wiggleAnimation.stop();
        }
    }

    SequentialAnimation {
        id: wiggleAnimation
        loops: Animation.Infinite
        RotationAnimation {
            target: root
            from: 0
            to: 5
            duration: 100
        }
        RotationAnimation {
            target: root
            from: 5
            to: 0
            duration: 100
        }
        RotationAnimation {
            target: root
            from: 0
            to: -5
            duration: 100
        }
        RotationAnimation {
            target: root
            from: -5
            to: 0
            duration: 100
        }
        onStopped: afterWiggle.start()
    }

    PropertyAnimation {
        id: afterWiggle
        target: root
        property: "rotation"
        to: 0
        duration: 100
        easing.type: Easing.OutBack
        alwaysRunToEnd: true
    }

    Component.onCompleted: {
        if (index === 0) {
            timeoutPieAnimation.start();
        }
        addAnimation.start();
    }

    property real progress: 1.0
    
    property PropertyAnimation timeoutPieAnimation: PropertyAnimation {
        target: root
        property: "progress"
        from: 1.0
        to: 0.0
        duration: modelData.expireTimeout
        running: false
        onStopped: {
            if (root.progress <= 0) {
                removeAnimation.start()
            }
        }
    }

    ParallelAnimation {
        id: addAnimation
        NumberAnimation {
            target: root
            property: "scale"
            from: 0.6
            to: targetScale
            duration: 400
            easing.type: Easing.OutQuad
        }
        NumberAnimation {
            target: root
            property: "opacity"
            from: 0
            to: targetOpacity
            duration: 400
            easing.type: Easing.OutQuad
        }
    }

    ParallelAnimation {
        id: removeAnimation
        NumberAnimation {
            target: root
            property: "scale"
            to: 0.6
            duration: 400
            easing.type: Easing.OutQuad
        }
        NumberAnimation {
            target: root
            property: "targetY"
            from: 0
            to: -200
            duration: 400
            easing.type: Easing.OutQuad
        }
        NumberAnimation {
            target: root
            property: "opacity"
            to: 0
            duration: 400
            easing.type: Easing.OutQuad
        }
        onStopped: {
            if (root.progress <= 0) {
                root.modelData.expire()
            } else {
                root.modelData.dismiss()
            }
        }
    }


    MouseArea {
        id: mouseArea
        enabled: root.index === 0
        anchors.fill: root
        property real startX
        property real startY

        onPressed: mouse => {
            startX = mouse.x;
            startY = mouse.y;
            xSnap.enabled = false;
            ySnap.enabled = false;

            timeoutPieAnimation.pause();
        }
        onPositionChanged: mouse => {
            if (pressed) {
                let dx = mouse.x - startX;
                let dy = mouse.y - startY;
                let d = Math.sqrt(root.dragX ** 2 + root.dragY ** 2);
                let resist = Math.max(0.2, 1.0 - (d / 450));

                root.dragX += dx * resist;
                root.dragY += dy * resist;
            }
        }
        onReleased: {
            if (root.discardThreshold) {
                removeAnimation.start();
            } else {
                xSnap.enabled = true;
                ySnap.enabled = true;
                root.dragX = 0;
                root.dragY = 0;
                timeoutPieAnimation.resume();
            }
        }
    }

    Behavior on dragX {
        id: xSnap
        enabled: false
        NumberAnimation {
            duration: 400
            easing.type: Easing.OutBack
        }
    }

    Behavior on dragY {
        id: ySnap
        enabled: false
        NumberAnimation {
            duration: 400
            easing.type: Easing.OutBack
        }
    }

    ColumnLayout {
        id: notifbtn
        anchors.fill: parent
        anchors.margins: Config.spacing
        spacing: Config.spacing / 2

        RowLayout {
            Layout.fillWidth: true
            spacing: Config.spacing

            CustomText {
                Layout.fillWidth: true
                Layout.preferredWidth: 0
                text: modelData.summary
                elide: Text.ElideRight
            }
            TimeoutPie {
                progress: root.progress
                fillColor: Theme.colors.foregroundDim
            }
            MaterialButton {
                iconPadding: 2
                iconName: "close"
                iconColor: Theme.colors.red
                onClicked: modelData.dismiss()
            }
        }
        CustomText {
            Layout.fillWidth: true
            Layout.preferredWidth: 0
            visible: text.length > 0
            text: modelData.body
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            maximumLineCount: 2
        }
        Image {
            visible: source.toString().length > 0
            source: modelData.image
            Layout.preferredWidth: 60
            Layout.preferredHeight: 60
        }
    }
}

