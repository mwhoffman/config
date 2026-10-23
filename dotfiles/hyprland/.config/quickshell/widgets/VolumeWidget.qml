import QtQuick
import Quickshell

import qs.components
import qs.services

// Volume of the default output, as a speaker icon (see VolumeIcon). Left-click
// mutes, and right-click lists outputs to switch to.
Item {
  id: root

  implicitWidth: icon.implicitWidth
  implicitHeight: icon.implicitHeight

  VolumeIcon {
    id: icon
    anchors.centerIn: parent
    volume: AudioService.level
    muted: AudioService.muted
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton

    onClicked: event => {
      if (event.button === Qt.RightButton) menu.openFromBar(root)
      else AudioService.toggleMute()
    }
  }

  Menu {
    id: menu

    // One radio entry per output, checked for the current default.
    model: AudioService.sinks.map(node => ({
      text: AudioService.label(node),
      buttonType: QsMenuButtonType.RadioButton,
      checkState: node === AudioService.sink ? Qt.Checked : Qt.Unchecked,
      triggered: () => AudioService.setDefault(node),
    }))
  }
}
