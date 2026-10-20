import QtQuick
import qs
import qs.components
import qs.services

BarText {
  text: Icons.clock + Qt.formatDateTime(Time.date, "MMM d HH:mm")
}
