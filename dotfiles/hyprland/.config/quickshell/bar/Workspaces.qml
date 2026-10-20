import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs
import qs.components

RowLayout {
  Repeater {
    model: 9

    BarText {
      required property int index
      property bool isFocused: Hyprland.focusedWorkspace?.id === (index + 1)
      property bool isActive: Hyprland.workspaces.values.some(w => w.id === index + 1)
      text: index + 1
      color: isFocused ? Theme.focused : (isActive ? Theme.active : Theme.inactive)
    }
  }
}
