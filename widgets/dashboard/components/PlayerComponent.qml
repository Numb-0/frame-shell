import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.config
import qs.utils

RowLayout {
    required property var modelData
    FrameAnimation {
        // only emit the signal when the position is actually changing.
        running: modelData.playbackState == MprisPlaybackState.Playing
        // emit the positionChanged signal every frame.
        onTriggered: modelData.positionChanged()
    }
    spacing: 0
    IconButton {
        visible: modelData.desktopEntry !== ""
        iconSource: Quickshell.iconPath(modelData.desktopEntry)
        iconSize: 25
        iconPadding: 10
        // Component.onCompleted: console.log("Icon source:", modelData.desktopEntry)
    }
    MaterialButton {
        // Fallback icon when no desktop entry is available
        visible: modelData.desktopEntry == ""
        iconName: "music_note"
        iconColor: Theme.colors.green
    }
    ColumnLayout {
        Layout.alignment: Qt.AlignVCenter
        Layout.fillWidth: true
        spacing: 0
        CustomText {
            text: modelData.trackTitle
            font.pixelSize: 15
            elide: Text.ElideRight
            Layout.preferredWidth: 300
        }
        CustomText {
            text: modelData.trackAlbum + " - " + modelData.trackArtist
            font.pixelSize: 13
            color: Theme.colors.foreground
            elide: Text.ElideRight
            Layout.preferredWidth: 300
        }
        
        Item {
            id: progressBarContainer
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            Layout.topMargin: 5
            
            property real progress: 0
            property bool seeking: false
            property real seekProgress: 0
            property point pressPosition: Qt.point(0, 0)
            
            Component.onCompleted: {
                progress = modelData.position / modelData.length
            }
            
            Connections {
                target: modelData
                function onPositionChanged() {
                    if (!progressBarContainer.seeking) {
                        progressBarContainer.progress = modelData.position / modelData.length
                    }
                }
            }
            
            Canvas {
                id: waveCanvas
                anchors.fill: parent
                
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    
                    var w = width
                    var h = height
                    var centerY = h / 2
                    var amplitude = 8
                    var frequency = 0.15
                    var progressX = w * (parent.seeking ? parent.seekProgress : parent.progress)
                    
                    // Draw background wave
                    ctx.beginPath()
                    ctx.moveTo(0, centerY)
                    for (var x = 0; x <= w; x += 2) {
                        var y = centerY + Math.sin(x * frequency) * amplitude
                        ctx.lineTo(x, y)
                    }
                    ctx.strokeStyle = Theme.colors.foreground
                    ctx.lineWidth = 2
                    ctx.globalAlpha = 0.3
                    ctx.stroke()
                    
                    // Draw progress wave
                    ctx.beginPath()
                    ctx.moveTo(0, centerY)
                    for (var x = 0; x <= progressX; x += 2) {
                        var y = centerY + Math.sin(x * frequency) * amplitude
                        ctx.lineTo(x, y)
                    }
                    ctx.strokeStyle = Theme.colors.green
                    ctx.lineWidth = 3
                    ctx.globalAlpha = 1.0
                    ctx.stroke()
                    
                    // Draw handle
                    ctx.beginPath()
                    var handleY = centerY + Math.sin(progressX * frequency) * amplitude
                    ctx.arc(progressX, handleY, 6, 0, 2 * Math.PI)
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
                    modelData.position = newProgress * modelData.length
                    parent.seeking = false
                }
            }
        }
        
        RowLayout {
            Layout.fillWidth: true
            spacing: 5
            
            function formatTime(seconds) {
                var minutes = Math.floor(seconds / 60)
                var secs = Math.floor(seconds % 60)
                return minutes + ":" + (secs < 10 ? "0" : "") + secs
            }
            
            CustomText {
                text: parent.formatTime(modelData.position)
                font.pixelSize: 11
                color: Theme.colors.foreground
            }
            
            Item { Layout.fillWidth: true }
            
            CustomText {
                text: parent.formatTime(modelData.length)
                font.pixelSize: 11
                color: Theme.colors.foreground
            }
        }
        
        RowLayout { 
            spacing: 0
            Layout.alignment: Qt.AlignHCenter
            MaterialButton {
                iconName: "skip_previous"
                iconColor: Theme.colors.green
                iconPadding: 0
                enabled: modelData.canGoPrevious
                onClicked: modelData.previous()
            }
            MaterialButton {
                id: playPauseButton
                iconName: modelData.isPlaying ? "pause" : "play_arrow"
                iconColor: Theme.colors.green
                iconPadding: 0
                onClicked: modelData.togglePlaying() 
            }
            MaterialButton {
                iconName: "skip_next"
                iconColor: Theme.colors.green
                iconPadding: 0
                enabled: modelData.canGoNext
                onClicked: modelData.next()
            }
        }
    }
}