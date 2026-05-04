pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import qs.services
import qs.utils
import qs.config
import Quickshell.Services.Notifications

PanelWindow {
    id: root
    property list<Notification> notifications
    property int notifWidth: 420
    property int notifHeight: 140
    property int iconSize: 18
    property int appNameSize: 12
    property int summarySize: 16
    property int bodySize: 12

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    exclusiveZone: 0
    color: "transparent"

    mask: Region {
        item: notifList.count > 0 ? maskBounds : null
    }

    QtObject {
        id: globalTracker
        property real topDragDist: 0
    }

    NotificationServer {
        id: notifServer
        onNotification: notif => {
            notif.tracked = true;
            root.notifications = [notif, ...root.notifications];
        }
    }

    Item {
        id: maskBounds
        anchors.horizontalCenter: notifList.horizontalCenter
        anchors.top: notifList.top
        width: notifList.width
        height: notifList.contentHeight
    }

    ListView {
        id: notifList
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Config.spacing
        width: root.notifWidth
        height: parent.height
        model: ScriptModel {
            values: [...root.notifications]
        }
        spacing: 0
        interactive: false

        header: Item {
            height: 160
            width: root.notifWidth
        }

        add: Transition { }
        displaced: Transition {
            NumberAnimation {
                properties: "y"
                duration: 450
                easing.type: Easing.OutQuint
            }
        }

        delegate: Item {
            id: delegateRoot
            required property Notification modelData
            required property int index
            property bool isDying: false
            property bool isSpawned: false

            // Progress tracker for the auto-dismiss timer and pie chart
            property real timeoutProgress: 1.0

            width: notifList.width
            height: 0
            z: -index

            Component.onCompleted: isSpawned = true

            // make sure it's discarded correctly (weird bug)
            Connections {
                target: delegateRoot.modelData
                ignoreUnknownSignals: true
                function onClosed() {
                    if (!delegateRoot.isDying)
                        delegateRoot.discard(true);
                }
            }

            // ^^^ Failsafe in case the backend object is instantly destroyed
            onModelDataChanged: {
                if (!modelData && !isDying) {
                    discard(true);
                }
            }

            NumberAnimation {
                id: timeoutAnim
                target: delegateRoot
                property: "timeoutProgress"
                from: 1.0
                to: 0.0
                duration: 5000
                running: delegateRoot.index === 0 && !delegateRoot.isDying && delegateRoot.isSpawned
                onFinished: delegateRoot.discard(false)
            }

            function discard(untrack: bool) {
                isDying = true;

                if (untrack) {
                    modelData.tracked = false;
                }

                // Delay list update slightly to let 'isDying' state settle
                Qt.callLater(() => {
                    root.notifications = root.notifications.filter(n => n !== null && n !== modelData);
                });
            }

            ListView.onRemove: removeAnimation.start()

            SequentialAnimation {
                id: removeAnimation
                PropertyAction {
                    target: delegateRoot
                    property: "ListView.delayRemove"
                    value: true
                }
                ParallelAnimation {
                    NumberAnimation {
                        target: visualContent
                        property: "scale"
                        to: 1
                        duration: 400
                        easing.type: Easing.OutQuad
                    }
                    NumberAnimation {
                        target: visualContent
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: 400
                        easing.type: Easing.OutQuad
                    }
                    NumberAnimation {
                        target: visualContent
                        property: "y"
                        from: 0
                        to: -visualContent.height / 8
                        duration: 400
                        easing.type: Easing.OutQuad
                    }
                }
                PropertyAction {
                    target: delegateRoot
                    property: "ListView.delayRemove"
                    value: false
                }
            }

            Rectangle {
                id: visualContent
                width: parent.width
                height: root.notifHeight
                radius: Config.rounding * 2

                color: Theme.colors.backgroundAlt
                border.color: Theme.colors.backgroundHighlight
                border.width: 0

                property real dragX: 0
                property real dragY: 0

                property real targetScale: delegateRoot.index === 0 ? 1.0 : Math.pow(0.94, delegateRoot.index)
                property real targetY: (delegateRoot.index * Config.spacing) - (root.notifHeight + 5)
                property real targetOpacity: delegateRoot.index === 0 ? 1.0 : Math.max(0, 0.8 * Math.pow(0.7, delegateRoot.index - 1))

                scale: !delegateRoot.isSpawned ? 0 : (delegateRoot.isDying ? 0 : targetScale)
                opacity: !delegateRoot.isSpawned ? 0 : (delegateRoot.isDying ? 0 : targetOpacity)

                Behavior on scale {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.OutBack
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

                transform: Translate {
                    x: visualContent.dragX
                    y: visualContent.dragY + visualContent.targetY
                }

                // Canvas to draw the Pie Chart indicator
                Canvas {
                    id: pieIndicator
                    width: 20
                    height: 20
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: Config.spacing
                    visible: delegateRoot.index === 0 && !delegateRoot.isDying && delegateRoot.timeoutProgress > 0

                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.clearRect(0, 0, width, height);

                        ctx.beginPath();
                        ctx.moveTo(width / 2, height / 2);
                        // Start at 12 o'clock (-90 degrees)
                        var startAngle = -Math.PI / 2;
                        var endAngle = startAngle + (delegateRoot.timeoutProgress * 2 * Math.PI);

                        ctx.arc(width / 2, height / 2, width / 2, startAngle, endAngle, false);
                        ctx.lineTo(width / 2, height / 2);

                        ctx.fillStyle = Theme.colors.foregroundDim;
                        ctx.fill();
                    }

                    Connections {
                        target: delegateRoot
                        function onTimeoutProgressChanged() {
                            pieIndicator.requestPaint();
                        }
                    }
                }

                Column {
                    anchors.fill: parent
                    anchors.margins: Config.spacing + 4
                    spacing: Math.max(4, Config.spacing / 2)

                    Row {
                        width: parent.width
                        spacing: Config.spacing

                        Image {
                            readonly property string icon: delegateRoot.modelData?.appIcon ?? ""
                            readonly property bool isFile: icon.includes("file://")

                            source: !isFile && icon !== "" ? Quickshell.iconPath(delegateRoot.modelData?.appIcon ?? "") : ""
                            width: root.iconSize
                            height: root.iconSize
                            fillMode: Image.PreserveAspectFit
                            visible: source != ""
                        }

                        Text {
                            text: delegateRoot.modelData?.appName
                            color: Theme.colors.foregroundDim
                            font.pointSize: root.appNameSize
                            font.bold: true
                            font.italic: true
                            elide: Text.ElideRight
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Text {
                        width: parent.width
                        text: delegateRoot.modelData?.summary
                        color: Theme.colors.foregroundBright
                        font.bold: true
                        font.pointSize: root.summarySize
                        elide: Text.ElideRight
                    }

                    Text {
                        width: parent.width
                        text: delegateRoot.modelData?.body
                        color: Theme.colors.foreground
                        font.pointSize: root.bodySize
                        maximumLineCount: 3
                        wrapMode: Text.WrapAnywhere
                        elide: Text.ElideRight
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
                        target: visualContent
                        from: 0
                        to: 5
                        duration: 100
                    }
                    RotationAnimation {
                        target: visualContent
                        from: 5
                        to: 0
                        duration: 100
                    }
                    RotationAnimation {
                        target: visualContent
                        from: 0
                        to: -5
                        duration: 100
                    }
                    RotationAnimation {
                        target: visualContent
                        from: -5
                        to: 0
                        duration: 100
                    }
                    onStopped: afterWiggle.start()
                }

                PropertyAnimation {
                    id: afterWiggle
                    target: visualContent
                    property: "rotation"
                    to: 0
                    duration: 100
                    easing.type: Easing.OutBack
                    alwaysRunToEnd: true
                }

                MouseArea {
                    id: mouseArea
                    enabled: delegateRoot.index === 0 && !delegateRoot.isDying
                    anchors.fill: parent
                    property real startX
                    property real startY

                    onPressed: mouse => {
                        startX = mouse.x;
                        startY = mouse.y;
                        xSnap.enabled = false;
                        ySnap.enabled = false;

                        // Optional: Pause the timeout timer while grabbing it
                        timeoutAnim.pause();
                    }
                    onPositionChanged: mouse => {
                        if (pressed) {
                            let dx = mouse.x - startX;
                            let dy = mouse.y - startY;
                            let d = Math.sqrt(visualContent.dragX ** 2 + visualContent.dragY ** 2);
                            let resist = Math.max(0.2, 1.0 - (d / 450));

                            visualContent.dragX += dx * resist;
                            visualContent.dragY += dy * resist;
                            globalTracker.topDragDist = Math.sqrt(visualContent.dragX ** 2 + visualContent.dragY ** 2);
                        }
                    }
                    onReleased: {
                        if (visualContent.discardThreshold) {
                            delegateRoot.discard(true);
                            globalTracker.topDragDist = 0;
                        } else {
                            xSnap.enabled = true;
                            ySnap.enabled = true;
                            visualContent.dragX = 0;
                            visualContent.dragY = 0;
                            globalTracker.topDragDist = 0;

                            // Resume the timeout if not discarded
                            timeoutAnim.resume();
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
            }
        }
    }
}
