import QtQuick

import qs
import qs.services

Text {
  text: Icons.clock + Qt.formatDateTime(Time.date, "MMM d HH:mm")
  color: Config.theme.active
  font {
    family: Config.fontFamily
    pointSize: Config.bar.fontSize
  }
}
