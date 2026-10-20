pragma Singleton
import Quickshell
import QtQuick

Singleton {
  readonly property color bg: "#1d2021"
  readonly property color focused: "#458588"
  readonly property color inactive: "#504945"
  readonly property color active: "#928374"
  readonly property string fontFamily: "JetBrainsMono Nerd Font"
  readonly property int fontSize: 16
  readonly property int widgetSpacing: 24
  readonly property int iconSize: 18

  // Popup menus (components/Menu.qml).
  readonly property color menuText: "#ebdbb2"
  readonly property int menuFontSize: 12
  readonly property int menuPadding: 6
  readonly property int menuRadius: 8
  // Extra drop below the tray icon so the menu clears the bar.
  readonly property int menuOffset: 12
}
