pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import qs.settings

// Power menu: log out, reboot or shut down (commands in Config.power).
//
// Toggled by the quickshell:powerMenu shortcut (bound in hyprland.lua). Dims
// the focused monitor and takes all keyboard input while open. Up/Down or j/k
// move, Enter or an option's letter runs it, and Escape, Cancel (C) or a
// click outside the card closes it.
PanelWindow {
  id: root

  property bool open: false
  property int selected: 0

  readonly property var options: [
    { label: "Log out", key: "L", glyph: Icons.logout, command: Config.power.logout },
    { label: "Reboot", key: "R", glyph: Icons.reboot, command: Config.power.reboot },
    { label: "Shut down", key: "S", glyph: Icons.shutdown, command: Config.power.shutdown },
    // Last, and shown below a divider; no command, so it just closes.
    { label: "Cancel", key: "C", glyph: Icons.cancel, command: "" },
  ]

  function show() {
    selected = 0
    open = true
  }

  function close() {
    open = false
  }

  function run(index) {
    close()
    const command = options[index].command
    if (command) Quickshell.execDetached(["sh", "-c", command])
  }

  function move(step) {
    selected = (selected + step + options.length) % options.length
  }

  screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0]
  visible: open

  anchors { top: true; bottom: true; left: true; right: true }
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "quickshell:power"
  WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
  color: Config.theme.backdrop

  onVisibleChanged: if (visible) keys.forceActiveFocus()

  GlobalShortcut {
    name: "powerMenu"
    description: "Open or close the power menu"
    onPressed: root.open ? root.close() : root.show()
  }

  // A click outside the card closes the menu.
  MouseArea {
    anchors.fill: parent
    onClicked: root.close()
  }

  Item {
    id: keys

    Keys.onPressed: event => {
      event.accepted = true
      switch (event.key) {
      case Qt.Key_Escape: root.close(); return
      case Qt.Key_Up: case Qt.Key_K: root.move(-1); return
      case Qt.Key_Down: case Qt.Key_J: root.move(1); return
      case Qt.Key_Return: case Qt.Key_Enter: root.run(root.selected); return
      }
      const index = root.options.findIndex(o => o.key === event.text.toUpperCase())
      if (index >= 0) root.run(index)
      else event.accepted = false
    }
  }

  component Divider: Rectangle {
    Layout.fillWidth: true
    implicitHeight: 1
    color: Config.theme.inactive
  }

  component MenuText: Text {
    textFormat: Text.PlainText
    color: Config.theme.active
    font { family: Config.fontFamily; pointSize: Config.dialog.fontSize }
  }

  // One selectable row: glyph, label and key, highlighted when selected.
  component OptionRow: Rectangle {
    id: option

    required property int index
    readonly property var modelData: root.options[index]
    readonly property bool current: root.selected === index

    Layout.fillWidth: true
    implicitHeight: row.implicitHeight + Config.dialog.padding
    radius: 4
    color: current ? Config.theme.focused : "transparent"

    RowLayout {
      id: row
      anchors { fill: parent; leftMargin: Config.dialog.padding / 2; rightMargin: Config.dialog.padding / 2 }
      spacing: 10

      MenuText {
        Layout.preferredWidth: titleGlyph.implicitWidth
        horizontalAlignment: Text.AlignHCenter
        text: option.modelData.glyph
        color: option.current ? Config.theme.text : Config.theme.active
      }

      MenuText {
        Layout.fillWidth: true
        text: option.modelData.label
        color: option.current ? Config.theme.text : Config.theme.active
      }

      MenuText {
        text: option.modelData.key
        color: option.current ? Config.theme.text : Config.theme.inactive
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onEntered: root.selected = option.index
      onClicked: root.run(option.index)
    }
  }

  Rectangle {
    anchors.centerIn: parent
    width: Config.dialog.width
    implicitHeight: content.implicitHeight + 2 * Config.dialog.padding
    color: Config.theme.bg
    border { color: Config.theme.inactive; width: 2 }
    radius: Config.dialog.radius

    // Swallow clicks on the card so they don't reach the backdrop.
    MouseArea {
      anchors.fill: parent
    }

    ColumnLayout {
      id: content
      anchors { fill: parent; margins: Config.dialog.padding }
      spacing: 10

      // Indented like the option rows, with every glyph centered in a column
      // as wide as the (larger) title glyph, so icons and labels line up.
      RowLayout {
        Layout.leftMargin: Config.dialog.padding / 2
        spacing: 10

        MenuText {
          id: titleGlyph
          text: Icons.shutdown
          color: Config.theme.text
          font.pointSize: Config.dialog.titleFontSize
        }

        MenuText {
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
          model: root.options.length - 1

          OptionRow {}
        }
      }

      Divider {}

      OptionRow {
        index: root.options.length - 1
      }
    }
  }
}
