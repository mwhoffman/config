import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

import qs.settings

// A selectable dialog row: a glyph or icon image, a label, and a dim hint on
// the right. Highlighted while `current`.
Rectangle {
  id: row

  property bool current: false
  // Either a font glyph or an image source; the image wins if both are set.
  property string glyph: ""
  property string image: ""
  // Width of the icon column; set the same on every row to line them up.
  property real iconWidth: glyphText.implicitWidth
  property string label: ""
  property string hint: ""
  property real hintFontSize: Config.dialog.fontSize
  // The hint shortens past this; the label takes the rest of the row.
  property real hintMaxWidth: width / 3

  signal hovered()
  signal clicked()

  Layout.fillWidth: true
  implicitHeight: content.implicitHeight + Config.dialog.padding
  radius: 4
  color: current ? Config.theme.focused : "transparent"

  RowLayout {
    id: content
    anchors { fill: parent; leftMargin: Config.dialog.padding / 2; rightMargin: Config.dialog.padding / 2 }
    spacing: 10

    Item {
      implicitWidth: row.iconWidth
      implicitHeight: Math.max(glyphText.implicitHeight, row.image ? row.iconWidth : 0)

      DialogText {
        id: glyphText
        anchors.centerIn: parent
        visible: !row.image
        text: row.glyph
        color: row.current ? Config.theme.text : Config.theme.active
      }

      IconImage {
        anchors.centerIn: parent
        visible: row.image !== ""
        implicitSize: row.iconWidth
        source: row.image
      }
    }

    DialogText {
      Layout.fillWidth: true
      text: row.label
      elide: Text.ElideRight
      color: row.current ? Config.theme.text : Config.theme.active
    }

    DialogText {
      text: row.hint
      elide: Text.ElideRight
      Layout.maximumWidth: row.hintMaxWidth
      color: row.current ? Config.theme.text : Config.theme.inactive
      font.pointSize: row.hintFontSize
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onEntered: row.hovered()
    onClicked: row.clicked()
  }
}
