import QtQuick

import qs.services
import qs.settings

Text {
  text: Icons.cpu + String(CpuService.usage).padStart(2, "0") + "%"
  color: Config.theme.active
  font {
    family: Config.fontFamily
    pointSize: Config.bar.fontSize
  }
}
