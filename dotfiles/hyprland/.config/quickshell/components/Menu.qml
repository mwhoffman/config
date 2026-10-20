import Quickshell
import QtQuick
import QtQuick.Layouts
import qs

// Themed popup menu with cascading submenus.
//
// Fill it one of two ways:
//   handle: a QsMenuHandle, such as a tray item's `menu`.
//   model:  a JS array of plain entries, for menus built in QML. Every
//           field is optional:
//             { text, icon, enabled, isSeparator, buttonType, checkState,
//               children: [...entries], triggered: () => {} }
//
// Position it with `anchor` (a PopupAnchor), then call open(). It closes
// on an outside click, or after an entry is triggered.
PopupWindow {
  id: root

  property QsMenuHandle handle: null
  property var model: []

  // Emitted when an entry in this menu, or any of its submenus, is triggered.
  signal activated(var entry)

  readonly property var entries: handle ? opener.children.values : model

  // Reserve an icon/check column when any entry needs one, so text lines up.
  readonly property bool hasGutter: Array.prototype.some.call(entries, e =>
    (e.icon ?? "") !== "" || (e.buttonType ?? QsMenuButtonType.None) !== QsMenuButtonType.None)

  // Row whose submenu is showing, if any.
  property Item submenuRow: null

  function open() { visible = true }
  function close() { visible = false }

  function activate(entry) {
    entry.triggered?.()
    activated(entry)
    close()
  }

  function showSubmenu(row) {
    if (row === submenuRow) return
    // Clear first so the loader rebuilds the submenu at its new anchor.
    submenuRow = null
    submenuRow = row
  }

  visible: false
  grabFocus: true
  color: "transparent"
  implicitWidth: background.implicitWidth
  implicitHeight: background.implicitHeight

  onVisibleChanged: if (!visible) submenuRow = null

  QsMenuOpener {
    id: opener
    menu: root.handle
  }

  Rectangle {
    id: background
    anchors.fill: parent
    implicitWidth: column.implicitWidth + 2 * Config.menu.padding
    implicitHeight: column.implicitHeight + 2 * Config.menu.padding
    color: Config.theme.bg
    border { color: Config.theme.inactive; width: 1 }
    radius: Config.menu.radius

    ColumnLayout {
      id: column
      anchors { fill: parent; margins: Config.menu.padding }
      spacing: 0

      Repeater {
        model: root.entries

        MenuItem {
          Layout.fillWidth: true
          menu: root
        }
      }
    }
  }

  // Loaded by URL because a component can't contain itself directly.
  LazyLoader {
    active: root.visible && root.submenuRow !== null
    source: Qt.resolvedUrl("Menu.qml")

    onItemChanged: {
      if (!item) return
      const entry = root.submenuRow.modelData
      // Plain entries list their children; menu handles load their own.
      if (entry.children !== undefined) {
        item.model = entry.children
      } else {
        item.handle = entry
      }
      item.anchor.item = root.submenuRow
      item.anchor.edges = Edges.Right | Edges.Top
      item.anchor.gravity = Edges.Right | Edges.Bottom
      item.activated.connect(e => {
        root.activated(e)
        root.close()
      })
      item.open()
    }
  }
}
