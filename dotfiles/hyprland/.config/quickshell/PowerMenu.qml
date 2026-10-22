pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import qs.components
import qs.settings

// Power menu: log out, reboot or shut down (commands in Config.power).
//
// Toggled by the quickshell:powerMenu shortcut (bound in hyprland.lua). Uses
// the shared dialog keys (see Dialog), plus each option's letter to run it.
Dialog {
  id: root

  property int selected: 0

  readonly property var options: [
    { label: "Log out", key: "L", glyph: Icons.logout, command: Config.power.logout },
    { label: "Reboot", key: "R", glyph: Icons.reboot, command: Config.power.reboot },
    { label: "Shut down", key: "S", glyph: Icons.shutdown, command: Config.power.shutdown },
  ]

  function show() {
    selected = 0
    open = true
  }

  function run(index) {
    open = false
    Quickshell.execDetached(["sh", "-c", options[index].command])
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
    iconWidth: titleGlyph.implicitWidth
    glyph: option.glyph
    label: option.label
    hint: option.key
    onHovered: root.selected = index
    onClicked: root.run(index)
  }

  // Indented like the option rows, with every glyph centered in a column as
  // wide as the (larger) title glyph, so icons and labels line up.
  RowLayout {
    Layout.leftMargin: Config.dialog.padding / 2
    spacing: 10

    DialogText {
      id: titleGlyph
      text: Icons.shutdown
      color: Config.theme.text
      font.pointSize: Config.dialog.titleFontSize
    }

    DialogText {
      text: "Power"
      color: Config.theme.text
      font { bold: true; pointSize: Config.dialog.titleFontSize }
    }
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
