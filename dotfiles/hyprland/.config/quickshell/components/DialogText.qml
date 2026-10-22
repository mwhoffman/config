import QtQuick

import qs.settings

// Plain dim text at the dialog font size.
Text {
  textFormat: Text.PlainText
  color: Config.theme.active
  font { family: Config.fontFamily; pointSize: Config.dialog.fontSize }
}
