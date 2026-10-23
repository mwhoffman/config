import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.settings
import qs.widgets

// The bar, along the top or bottom of the screen (Config.bar.position).
PanelWindow {
  required property var modelData
  screen: modelData

  implicitHeight: Config.bar.height
  color: Config.theme.bg
  anchors {
    top: Config.bar.position === "top"
    bottom: Config.bar.position !== "top"
    left: true
    right: true
  }

  RowLayout {
    spacing: Config.bar.spacing

    anchors {
      fill: parent
      leftMargin: 10
      rightMargin: 10
    }

    WorkspaceWidget {}
    Item { Layout.fillWidth: true }
    TrayWidget {}
    BluetoothWidget {}
    VolumeWidget {}
    ClockWidget {}
  }
}
