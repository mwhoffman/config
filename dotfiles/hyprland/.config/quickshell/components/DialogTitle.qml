import QtQuick
import QtQuick.Layouts

import qs.settings

// A dialog's title: a glyph and bold text, indented like DialogRow so the
// glyph sits in the rows' icon column. Rows can use `glyphWidth` as their
// iconWidth to line up with it.
RowLayout {
  id: title

  property string glyph: ""
  property string text: ""
  readonly property real glyphWidth: glyphText.implicitWidth

  Layout.leftMargin: Config.dialog.padding / 2
  spacing: 10

  DialogText {
    id: glyphText
    text: title.glyph
    color: Config.theme.text
    font.pointSize: Config.dialog.titleFontSize
  }

  DialogText {
    Layout.fillWidth: true
    text: title.text
    color: Config.theme.text
    font { bold: true; pointSize: Config.dialog.titleFontSize }
  }
}
