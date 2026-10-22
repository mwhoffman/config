pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import qs.settings

// A centered dialog over a dimmed focused monitor, as used by the power menu
// and launcher. While open it takes all keyboard input.
//
// Children are laid out in a column inside the card. A click outside the card
// emits dismissed(), unless `closeOnClickOutside` is off.
//
// Every dialog uses the same keys, interpreted by handleKey():
//   Up, Ctrl+K, Ctrl+P      moved(-1)
//   Down, Ctrl+J, Ctrl+N    moved(1)
//   k, j                    the same, unless the dialog has a text field
//   Enter                   accepted()
//   Escape                  dismissed()
// Other keys are emitted as keyPressed. A dialog with a text field sets it as
// `initialFocus` and calls handleKey(event, true) from its key handler.
PanelWindow {
  id: root

  property bool open: false
  // Layer namespace suffix, e.g. "power" gives "quickshell:power".
  property string name: "dialog"
  // Item focused when the dialog opens; a text field, say.
  property Item initialFocus: keys
  // Off for dialogs where an accidental close matters, like the auth prompt.
  property bool closeOnClickOutside: true

  default property alias content: column.data

  signal moved(int step)
  signal accepted()
  signal dismissed()
  // Keys handleKey() didn't use, when the dialog has no text field.
  signal keyPressed(var event)

  // Applies the shared dialog keys to `event`, returning whether it was used.
  // With `textEntry`, plain k and j are left for typing.
  function handleKey(event: var, textEntry: bool): bool {
    const ctrl = event.modifiers & Qt.ControlModifier
    const plain = !textEntry && !ctrl
    if (event.key === Qt.Key_Up || (ctrl || plain) && event.key === Qt.Key_K || ctrl && event.key === Qt.Key_P) {
      moved(-1)
    } else if (event.key === Qt.Key_Down || (ctrl || plain) && event.key === Qt.Key_J || ctrl && event.key === Qt.Key_N) {
      moved(1)
    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
      accepted()
    } else if (event.key === Qt.Key_Escape) {
      dismissed()
    } else {
      return false
    }
    return true
  }

  screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0]
  visible: open

  anchors { top: true; bottom: true; left: true; right: true }
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "quickshell:" + name
  WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
  color: Config.theme.backdrop

  onVisibleChanged: if (visible) initialFocus.forceActiveFocus()

  // Clicks outside the card never reach the windows below.
  MouseArea {
    anchors.fill: parent
    onClicked: if (root.closeOnClickOutside) root.dismissed()
  }

  Item {
    id: keys
    Keys.onPressed: event => {
      event.accepted = root.handleKey(event, false)
      if (!event.accepted) root.keyPressed(event)
    }
  }

  Rectangle {
    anchors.centerIn: parent
    width: Config.dialog.width
    implicitHeight: column.implicitHeight + 2 * Config.dialog.padding
    color: Config.theme.bg
    border { color: Config.theme.inactive; width: 2 }
    radius: Config.dialog.radius

    // Swallow clicks on the card so they don't reach the backdrop.
    MouseArea {
      anchors.fill: parent
    }

    ColumnLayout {
      id: column
      anchors { fill: parent; margins: Config.dialog.padding }
      spacing: 10
    }
  }
}
