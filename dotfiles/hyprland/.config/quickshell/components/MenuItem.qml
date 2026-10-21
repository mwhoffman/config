pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import qs.settings

// One row of a Menu: either a separator, or an entry with an optional
// icon or check mark, its text, and an arrow if it has a submenu.
Item {
  id: row

  required property var modelData
  required property Menu menu

  readonly property bool separator: modelData.isSeparator ?? false
  readonly property string text: modelData.text ?? ""
  readonly property string icon: modelData.icon ?? ""
  readonly property int buttonType: modelData.buttonType ?? QsMenuButtonType.None
  readonly property bool checked: modelData.checkState === Qt.Checked
  readonly property bool hasSubmenu: modelData.hasChildren ?? (modelData.children?.length > 0)
  readonly property bool highlighted: mouse.containsMouse || menu.submenuRow === row

  enabled: modelData.enabled ?? true
  implicitWidth: separator ? 0 : content.implicitWidth + 2 * Config.menu.padding
  implicitHeight: separator ? 2 * Config.menu.padding + 1 : content.implicitHeight + 2 * Config.menu.padding

  component MenuText: Text {
    color: row.enabled ? Config.theme.text : Config.theme.active
    font { family: Config.fontFamily; pointSize: Config.menu.fontSize }
  }

  Rectangle {
    visible: row.separator
    anchors { verticalCenter: parent.verticalCenter; left: parent.left; right: parent.right }
    height: 1
    color: Config.theme.inactive
  }

  Rectangle {
    anchors.fill: parent
    visible: !row.separator && row.enabled && row.highlighted
    color: Config.theme.focused
    radius: Config.menu.radius / 2
  }

  RowLayout {
    id: content
    visible: !row.separator
    anchors { fill: parent; leftMargin: Config.menu.padding; rightMargin: Config.menu.padding }
    spacing: Config.menu.padding

    Item {
      visible: row.menu.hasGutter
      implicitWidth: Config.bar.iconSize
      implicitHeight: Config.bar.iconSize

      MenuText {
        anchors.centerIn: parent
        visible: row.buttonType !== QsMenuButtonType.None
        text: row.buttonType === QsMenuButtonType.RadioButton
          ? (row.checked ? Icons.radioOn : Icons.radioOff)
          : (row.checked ? Icons.checkboxOn : Icons.checkboxOff)
      }

      IconImage {
        anchors.fill: parent
        visible: row.buttonType === QsMenuButtonType.None && row.icon !== ""
        source: row.icon
      }
    }

    MenuText {
      Layout.fillWidth: true
      text: row.text
    }

    MenuText {
      visible: row.hasSubmenu
      text: Icons.submenu
    }
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    enabled: !row.separator
    hoverEnabled: true
    onEntered: row.menu.showSubmenu(row.hasSubmenu ? row : null)
    onClicked: {
      if (row.hasSubmenu) row.menu.showSubmenu(row)
      else row.menu.activate(row.modelData)
    }
  }
}
