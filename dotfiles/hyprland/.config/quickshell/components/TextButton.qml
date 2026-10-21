import QtQuick

import qs.settings

// A flat button with a text label, in the theme's colors.
Rectangle {
  id: button

  property alias text: label.text
  property alias font: label.font
  property real padding: 8
  // Draws in the focused color, for the action Enter triggers.
  property bool primary: false

  signal clicked()

  implicitWidth: label.implicitWidth + 4 * padding
  implicitHeight: label.implicitHeight + 2 * padding
  radius: 4
  opacity: enabled ? 1 : 0.5
  color: primary || (enabled && area.containsMouse) ? Config.theme.focused : Config.theme.inactive

  Text {
    id: label
    anchors.centerIn: parent
    color: Config.theme.text
    font.family: Config.fontFamily
  }

  MouseArea {
    id: area
    anchors.fill: parent
    hoverEnabled: true
    onClicked: button.clicked()
  }
}
