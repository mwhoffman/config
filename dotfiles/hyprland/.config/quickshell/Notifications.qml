pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Notifications
import Quickshell.Wayland

import qs.components
import qs.services
import qs.settings

// Notification popups, stacked newest first in the top-right corner of the
// focused monitor, just below the bar.
PanelWindow {
  screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0]
  visible: NotificationService.count > 0

  anchors { top: true; right: true; bottom: true }
  margins { top: Config.notifications.margin; right: Config.notifications.margin }
  // Sit below the bar's reserved space without reserving any of our own.
  exclusionMode: ExclusionMode.Normal
  exclusiveZone: 0
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "quickshell:notifications"
  color: "transparent"
  implicitWidth: Config.notifications.width
  mask: Region { item: list }

  ListView {
    id: list
    anchors { top: parent.top; left: parent.left; right: parent.right }
    height: contentHeight
    interactive: false
    spacing: Config.notifications.spacing
    // The model is oldest first; draw it from the bottom up.
    verticalLayoutDirection: ListView.BottomToTop
    model: NotificationService.list

    delegate: NotificationCard {
      required property Notification modelData

      width: ListView.view.width
      notification: modelData
    }
  }
}
