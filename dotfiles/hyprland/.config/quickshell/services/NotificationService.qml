pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// Notification daemon (org.freedesktop.Notifications). Each notification is
// kept in `list` until it expires or is dismissed.
Singleton {
  id: root

  // ObjectModel of Notification, oldest first.
  readonly property alias list: server.trackedNotifications
  readonly property int count: server.trackedNotifications.values.length

  NotificationServer {
    id: server

    keepOnReload: true
    actionsSupported: true
    bodySupported: true
    bodyMarkupSupported: true
    imageSupported: true

    onNotification: notification => notification.tracked = true
  }
}
