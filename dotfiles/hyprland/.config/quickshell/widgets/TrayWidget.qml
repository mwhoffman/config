pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import qs.components
import qs.settings

// System tray (StatusNotifierItem) icons, e.g. 1Password, nm-applet.
// Items listed in Icons.tray show a Nerd Font glyph instead of their own icon.
RowLayout {
  id: tray
  // Spaced like the bar's widgets, so each tray icon reads as one more widget.
  spacing: Config.bar.spacing

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

      implicitWidth: glyph ? glyphText.implicitWidth : Config.bar.iconSize
      implicitHeight: glyph ? glyphText.implicitHeight : Config.bar.iconSize

      Text {
        id: glyphText
        anchors.centerIn: parent
        visible: item.glyph !== ""
        text: item.glyph
        color: Config.theme.active
        font {
          family: Config.fontFamily
          pointSize: Config.bar.fontSize
        }
      }

      IconImage {
        anchors.centerIn: parent
        visible: item.glyph === ""
        implicitSize: Config.bar.iconSize
        source: item.glyph ? "" : item.modelData.icon
      }

      Menu {
        id: menu
        handle: item.modelData.menu
      }

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: event => {
          if (event.button === Qt.MiddleButton) {
            item.modelData.secondaryActivate()
          } else if (event.button === Qt.RightButton || item.modelData.onlyMenu) {
            if (item.modelData.hasMenu) menu.openFromBar(item)
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
