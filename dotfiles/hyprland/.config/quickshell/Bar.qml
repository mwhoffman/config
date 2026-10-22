import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.settings
import qs.widgets

PanelWindow {
  required property var modelData
  screen: modelData

  implicitHeight: Config.bar.height
  color: Config.theme.bg
  anchors { top: true; left: true; right: true }

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
