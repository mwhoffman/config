import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs
import qs.components

// System tray (StatusNotifierItem) icons, e.g. 1Password, nm-applet.
// Items listed in Icons.tray show a Nerd Font glyph instead of their own icon.
RowLayout {
  id: tray
  spacing: 8

  // Left-click actions for apps that ignore a plain click (AppIndicators such
  // as Spotify only offer a menu). Keyed by the start of the tray item's id;
  // a click triggers the first menu entry whose text is listed. The app hides
  // entries that don't apply, so listing both halves of a toggle works.
  readonly property var clickEntries: ({
    "spotify-client": ["Show Spotify", "Minimize to Tray"],
  })

  function clickEntry(id: string, entries: var): var {
    for (const prefix in clickEntries) {
      if (!id.startsWith(prefix)) continue
      const labels = clickEntries[prefix]
      return Array.prototype.find.call(entries, e => labels.includes(e.text)) ?? null
    }
    return null
  }

  Repeater {
    model: SystemTray.items

    Item {
      id: item

      required property SystemTrayItem modelData
      readonly property string glyph: Icons.trayIcon(modelData.id)

      implicitWidth: glyph ? glyphText.implicitWidth : Theme.iconSize
      implicitHeight: glyph ? glyphText.implicitHeight : Theme.iconSize

      BarText {
        id: glyphText
        anchors.centerIn: parent
        visible: item.glyph !== ""
        text: item.glyph
      }

      IconImage {
        anchors.centerIn: parent
        visible: item.glyph === ""
        implicitSize: Theme.iconSize
        source: item.glyph ? "" : item.modelData.icon
      }

      Menu {
        id: menu
        handle: item.modelData.menu
        anchor {
          item: item
          rect.w: item.width
          rect.h: item.height + Theme.menuOffset
          edges: Edges.Bottom
          gravity: Edges.Bottom
        }
      }

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: event => {
          if (event.button === Qt.MiddleButton) {
            item.modelData.secondaryActivate()
          } else if (event.button === Qt.RightButton || item.modelData.onlyMenu) {
            if (item.modelData.hasMenu) menu.open()
          } else {
            const entry = tray.clickEntry(item.modelData.id, menu.entries)
            if (entry) entry.triggered()
            else item.modelData.activate()
          }
        }
      }
    }
  }
}
