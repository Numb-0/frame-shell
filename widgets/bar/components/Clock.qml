import QtQuick
import qs.utils
import Quickshell



CustomText {
  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
  text: Qt.formatDateTime(clock.date, "hh:mm")
}
