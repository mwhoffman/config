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
  // In the focused color: primary, or hovered.
  readonly property bool lit: primary || (enabled && area.containsMouse)

  signal clicked()

  implicitWidth: label.implicitWidth + 4 * padding
  implicitHeight: label.implicitHeight + 2 * padding
  radius: 4
  opacity: enabled ? 1 : 0.5
  color: lit ? Config.theme.focused : Config.theme.inactive

  Text {
    id: label
    anchors.centerIn: parent
    color: button.lit ? Config.theme.focusedText : Config.theme.inactiveText
    font.family: Config.fontFamily
  }

  MouseArea {
    id: area
    anchors.fill: parent
    hoverEnabled: true
    onClicked: button.clicked()
  }
}
