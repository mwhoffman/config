pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import qs.components
import qs.services
import qs.settings

// Power menu: lock, log out, reboot or shut down (commands in Config.power).
//
// Toggled by the quickshell:powerMenu shortcut (bound in hyprland.lua). Uses
// the shared dialog keys (see Dialog), plus each option's letter to run it.
Dialog {
  id: root

  property int selected: 0

  // Each runs `action` if it has one, otherwise its shell `command`.
  readonly property var options: [
    { label: "Lock", key: "L", glyph: Icons.lock, action: () => LockService.lock() },
    { label: "Log out", key: "O", glyph: Icons.logout, command: Config.power.logout },
    { label: "Reboot", key: "R", glyph: Icons.reboot, command: Config.power.reboot },
    { label: "Shut down", key: "S", glyph: Icons.shutdown, command: Config.power.shutdown },
  ]

  function show() {
    selected = 0
    open = true
  }

  function run(index) {
    open = false
    const option = options[index]
    if (option.action) option.action()
    else Quickshell.execDetached(["sh", "-c", option.command])
  }

  function move(step) {
    selected = (selected + step + options.length) % options.length
  }

  name: "power"
  onMoved: step => move(step)
  onAccepted: run(selected)
  onDismissed: open = false

  onKeyPressed: event => {
    const index = options.findIndex(o => o.key === event.text.toUpperCase())
    if (index >= 0) run(index)
  }

  GlobalShortcut {
    name: "powerMenu"
    description: "Open or close the power menu"
    onPressed: root.open ? root.open = false : root.show()
  }

  component OptionRow: DialogRow {
    required property int index
    readonly property var option: root.options[index]

    current: root.selected === index
    iconWidth: title.glyphWidth
    glyph: option.glyph
    label: option.label
    hint: option.key
    onHovered: root.selected = index
    onClicked: root.run(index)
  }

  // Rows center their glyphs in a column as wide as the (larger) title glyph,
  // so icons and labels line up.
  DialogTitle {
    id: title
    glyph: Icons.shutdown
    text: "Power"
  }

  Divider {}

  ColumnLayout {
    Layout.fillWidth: true
    spacing: 2

    Repeater {
      model: root.options.length

      OptionRow {}
    }
  }
}
