pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  property var date: new Date()
  readonly property string time: date.toLocaleString(Qt.locale(), "HH:mm")

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: date = new Date()
  }
}
