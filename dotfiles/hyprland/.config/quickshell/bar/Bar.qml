import Quickshell
import QtQuick
import QtQuick.Layouts
import qs

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

    Workspaces {}
    Item { Layout.fillWidth: true }
    Tray {}
    VolumeWidget {}
    CpuWidget {}
    MemoryWidget {}
    ClockWidget {}
  }
}
