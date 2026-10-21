import QtQuick

import qs
import qs.services

Text {
  text: Icons.memory + String(Memory.usage).padStart(2, "0") + "%"
  color: Config.theme.active
  font {
    family: Config.fontFamily
    pointSize: Config.bar.fontSize
  }
}
