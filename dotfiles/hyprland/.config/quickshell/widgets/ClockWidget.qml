import QtQuick

import qs.services
import qs.settings

Text {
  text: Qt.formatDateTime(TimeService.date, "ddd MMM d HH:mm")  // e.g. Fri Oct 23 00:47
  color: Config.theme.active
  font {
    family: Config.fontFamily
    pointSize: Config.bar.fontSize
  }
}
