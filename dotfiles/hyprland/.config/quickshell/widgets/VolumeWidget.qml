import QtQuick
import Quickshell

import qs.components
import qs.services
import qs.settings

// Volume of the default output. Right-click lists outputs to switch to.
Text {
  id: root

  text: Icons.volume + String(AudioService.volume).padStart(2, "0") + "%"
  color: Config.theme.active
  font {
    family: Config.fontFamily
    pointSize: Config.bar.fontSize
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.RightButton
    onClicked: menu.open()
  }

  Menu {
    id: menu

    anchor {
      item: root
      rect.w: root.width
      rect.h: root.height + Config.menu.offset
      edges: Edges.Bottom
      gravity: Edges.Bottom
    }

    // One radio entry per output, checked for the current default.
    model: AudioService.sinks.map(node => ({
      text: AudioService.label(node),
      buttonType: QsMenuButtonType.RadioButton,
      checkState: node === AudioService.sink ? Qt.Checked : Qt.Unchecked,
      triggered: () => AudioService.setDefault(node),
    }))
  }
}
