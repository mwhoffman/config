pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import qs.settings

// Workspaces in use, as numbered boxes like i3bar's: the focused one in the
// focused color, an urgent one in the urgent fill color, one shown on another
// monitor outlined, and the rest in the inactive color. Click to switch.
//
// Shows the workspaces that are focused or have windows. Hyprland removes an
// empty workspace when you leave it, but reports the focus change first, so
// the empty one is also skipped here; otherwise it flashes as a stale box.
// Special (scratchpad) workspaces, which have negative ids, are left out.
RowLayout {
  spacing: Config.bar.workspaceSpacing

  Repeater {
    model: Hyprland.workspaces.values
      .filter(workspace => workspace.id > 0)
      .filter(workspace => workspace.toplevels.values.length > 0 || Hyprland.focusedWorkspace === workspace)
      .sort((a, b) => a.id - b.id)

    Rectangle {
      id: box

      required property HyprlandWorkspace modelData
      readonly property bool focused: Hyprland.focusedWorkspace === modelData
      readonly property bool elsewhere: modelData.active && !focused

      implicitHeight: Config.bar.statusIconSize
      // Square for one digit; wider only for two (e.g. 10).
      implicitWidth: Math.max(implicitHeight, label.implicitWidth + implicitHeight / 3)
      radius: Config.bar.workspaceRadius
      color: modelData.urgent ? Config.theme.urgentFill
        : focused ? Config.theme.focused
        : elsewhere ? "transparent"
        : Config.theme.inactive
      border { width: elsewhere ? 2 : 0; color: Config.theme.focused }

      // Centers the number's visible shape rather than its character cell,
      // which in this font sits a pixel or two off for some digits.
      TextMetrics {
        id: metrics
        font: label.font
        text: label.text
      }

      Text {
        id: label
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: metrics.advanceWidth / 2
          - (metrics.tightBoundingRect.x + metrics.tightBoundingRect.width / 2)
        text: box.modelData.id
        color: box.focused || box.modelData.urgent ? Config.theme.text : Config.theme.active
        font { family: Config.fontFamily; pointSize: Config.bar.fontSize }
      }

      MouseArea {
        anchors.fill: parent
        onClicked: box.modelData.activate()
      }
    }
  }
}
