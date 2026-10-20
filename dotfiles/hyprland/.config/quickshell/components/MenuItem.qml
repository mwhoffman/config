import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs

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
  implicitWidth: separator ? 0 : content.implicitWidth + 2 * Theme.menuPadding
  implicitHeight: separator ? 2 * Theme.menuPadding + 1 : content.implicitHeight + 2 * Theme.menuPadding

  component MenuText: Text {
    color: row.enabled ? Theme.menuText : Theme.active
    font { family: Theme.fontFamily; pointSize: Theme.menuFontSize }
  }

  Rectangle {
    visible: row.separator
    anchors { verticalCenter: parent.verticalCenter; left: parent.left; right: parent.right }
    height: 1
    color: Theme.inactive
  }

  Rectangle {
    anchors.fill: parent
    visible: !row.separator && row.enabled && row.highlighted
    color: Theme.focused
    radius: Theme.menuRadius / 2
  }

  RowLayout {
    id: content
    visible: !row.separator
    anchors { fill: parent; leftMargin: Theme.menuPadding; rightMargin: Theme.menuPadding }
    spacing: Theme.menuPadding

    Item {
      visible: row.menu.hasGutter
      implicitWidth: Theme.iconSize
      implicitHeight: Theme.iconSize

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
