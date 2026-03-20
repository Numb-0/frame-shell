import QtQuick
import qs.utils
import Quickshell


CustomText {
  property bool showFullDate: false

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  text: showFullDate
    ? Qt.formatDateTime(clock.date, "ddd dd MMM yyyy hh:mm")
    : Qt.formatDateTime(clock.date, "hh:mm")

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: parent.showFullDate = !parent.showFullDate
  }
}
