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
  spacing: 8

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

      QsMenuAnchor {
        id: menu
        menu: item.modelData.menu
        anchor.item: item
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
            item.modelData.activate()
          }
        }
      }
    }
  }
}
