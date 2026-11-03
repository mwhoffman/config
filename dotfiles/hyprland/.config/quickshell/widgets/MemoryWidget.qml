import QtQuick

import qs.services
import qs.settings

Text {
  text: Icons.memory + String(MemoryService.usage).padStart(2, "0") + "%"
  color: Config.theme.dim
  font {
    family: Config.fontFamily
    pointSize: Config.bar.fontSize
  }
}
