import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import qs

RowLayout {
  Repeater {
    model: 9

    Text {
      required property int index
      property bool isFocused: Hyprland.focusedWorkspace?.id === (index + 1)
      property bool isActive: Hyprland.workspaces.values.some(w => w.id === index + 1)
      text: index + 1
      color: isFocused ? Config.theme.focused : (isActive ? Config.theme.active : Config.theme.inactive)
      font {
        family: Config.fontFamily
        pointSize: Config.bar.fontSize
      }
    }
  }
}
