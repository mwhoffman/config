import QtQuick
import QtQuick.Layouts

import qs.settings

// A full-width horizontal line in a layout.
Rectangle {
  Layout.fillWidth: true
  implicitHeight: 1
  color: Config.theme.inactive
}
