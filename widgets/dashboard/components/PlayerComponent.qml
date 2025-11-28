import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.config
import qs.utils

Item {
    id: root
    required property var modelData
    width: ListView.view ? ListView.view.width : parent.width
    height: contentLayout.implicitHeight + 10

    FrameAnimation {
        // only emit the signal when the position is actually changing.
        running: modelData.playbackState == MprisPlaybackState.Playing
        // emit the positionChanged signal every frame.
        onTriggered: modelData?.positionChanged()
    }

    Rectangle { 
        color: Theme.colors.backgroundHighlight
        radius: Config.rounding
        anchors.fill: parent
        anchors.margins: -5
    }

    RowLayout {
        id: contentLayout
        anchors.fill: parent
        spacing: 0
        
        ColumnLayout {
        Layout.alignment: Qt.AlignVCenter
        Layout.fillWidth: true
        spacing: 0
        CustomText {
            id: trackTitle
            text: modelData.trackTitle
            font.pixelSize: 15
            elide: Text.ElideRight
            Layout.preferredWidth: 300
            onTextChanged: {
                fadeAnimationTrack.start()
            }
            Animations.Fade {
                id: fadeAnimationTrack
                target: trackTitle
                duration: 400
            }
        }
        CustomText {
            id: artistAlbumText
            text: modelData.trackArtist
            font.pixelSize: 13
            color: Theme.colors.foreground
            elide: Text.ElideRight
            Layout.preferredWidth: 300
            transform: Translate { id: slideTransform }
            onTextChanged: {
                fadeAnimationTrackAlbum.start()
            }
            Animations.Fade {
                id: fadeAnimationTrackAlbum
                target: artistAlbumText
                duration: 400
            }
        }
        
        Item {
            id: progressBarContainer
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            Layout.topMargin: 5
            
            property real progress: modelData.position / modelData.length
            property bool seeking: false
            property real seekProgress: 0
            property point pressPosition: Qt.point(0, 0)
            property bool animating: false
            property real targetProgress: 0
            
            Connections {
                target: modelData
                function onPositionChanged() {
                    if (!progressBarContainer.seeking && !progressBarContainer.animating) {
                        progressBarContainer.progress = modelData.position / modelData.length
                    }
                }
            }
            
            NumberAnimation {
                id: progressAnimation
                target: progressBarContainer
                property: "progress"
                duration: 300
                easing.type: Easing.OutCubic
                onFinished: {
                    progressBarContainer.animating = false
                    modelData.position = progressBarContainer.targetProgress * modelData.length
                }
            }
            
            Canvas {
                id: waveCanvas
                anchors.fill: parent
                
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    
                    var handleRadius = 6
                    var padding = handleRadius
                    var w = width - (padding * 2)
                    var h = height
                    var centerY = h / 2
                    var amplitude = 8
                    var frequency = 0.15
                    var progressX = padding + (w * (parent.seeking ? parent.seekProgress : parent.progress))
                    
                    // Draw background wave
                    ctx.beginPath()
                    ctx.moveTo(padding, centerY)
                    for (var x = padding; x <= w + padding; x += 2) {
                        var y = centerY + Math.sin((x - padding) * frequency) * amplitude
                        ctx.lineTo(x, y)
                    }
                    ctx.strokeStyle = Theme.colors.foreground
                    ctx.lineWidth = 2
                    ctx.globalAlpha = 0.3
                    ctx.stroke()
                    
                    // Draw progress wave
                    ctx.beginPath()
                    ctx.moveTo(padding, centerY)
                    for (var x = padding; x <= progressX; x += 2) {
                        var y = centerY + Math.sin((x - padding) * frequency) * amplitude
                        ctx.lineTo(x, y)
                    }
                    ctx.strokeStyle = Theme.colors.green
                    ctx.lineWidth = 3
                    ctx.globalAlpha = 1.0
                    ctx.stroke()
                    
                    // Draw handle
                    ctx.beginPath()
                    var handleY = centerY + Math.sin((progressX - padding) * frequency) * amplitude
                    ctx.arc(progressX, handleY, handleRadius, 0, 2 * Math.PI)
                    ctx.fillStyle = Theme.colors.green
                    ctx.fill()
                }
            }
            
            Connections {
                target: progressBarContainer
                function onProgressChanged() { waveCanvas.requestPaint() }
                function onSeekProgressChanged() { waveCanvas.requestPaint() }
            }
            
            MouseArea {
                anchors.fill: parent
                onPressed: function(mouse) {
                    parent.pressPosition = Qt.point(mouse.x, mouse.y)
                    parent.seeking = false
                }
                onPositionChanged: function(mouse) {
                    var distance = Math.sqrt(Math.pow(mouse.x - parent.pressPosition.x, 2) + 
                                           Math.pow(mouse.y - parent.pressPosition.y, 2))
                    if (distance > 5) {
                        parent.seeking = true
                    }
                    
                    if (parent.seeking) {
                        parent.seekProgress = Math.max(0, Math.min(1, mouse.x / width))
                    }
                }
                onReleased: function(mouse) {
                    var newProgress = Math.max(0, Math.min(1, mouse.x / width))
                    
                    if (parent.seeking) {
                        // If dragging, update immediately
                        modelData.position = newProgress * modelData.length
                        parent.seeking = false
                    } else {
                        // If clicking, animate to position
                        parent.animating = true
                        parent.targetProgress = newProgress
                        progressAnimation.to = newProgress
                        progressAnimation.start()
                    }
                }
            }
        }
        
        RowLayout { 
            spacing: 0
            Layout.alignment: Qt.AlignHCenter
            MaterialButton {
                id: previousButton
                iconName: "skip_previous"
                iconColor: Theme.colors.green
                iconSize: 30
                iconPadding: 0
                enabled: modelData.canGoPrevious
                onClicked: {
                    modelData.previous()
                    wiggleAnimationPrevious.start()
                }
                Animations.WiggleAnimation {
                    id: wiggleAnimationPrevious
                    target: previousButton
                }
            }
            MaterialButton {
                id: playPauseButton
                iconName: modelData.isPlaying ? "pause" : "play_arrow"
                iconColor: Theme.colors.green
                iconSize: 30
                iconPadding: 0
                onClicked: {
                    modelData.togglePlaying()
                    wiggleAnimationPlayPause.start()
                }
                Animations.WiggleAnimation {
                    id: wiggleAnimationPlayPause
                    target: playPauseButton
                }
            }
            MaterialButton {
                id: nextButton
                iconName: "skip_next"
                iconColor: Theme.colors.green
                iconSize: 30
                iconPadding: 0
                enabled: modelData.canGoNext
                onClicked: {
                    modelData.next()
                    wiggleAnimationNext.start()
                }

                Animations.WiggleAnimation {
                    id: wiggleAnimationNext
                    target: nextButton
                }
            }
        }
        }
    }
}