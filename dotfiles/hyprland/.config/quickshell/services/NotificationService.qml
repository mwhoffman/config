pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// Notification daemon (org.freedesktop.Notifications). Each notification is
// kept in `list` until it expires or is dismissed. Notifications carry no
// timestamp, so arrival times are recorded here (see arrival()).
Singleton {
  id: root

  // ObjectModel of Notification, oldest first.
  readonly property alias list: server.trackedNotifications
  readonly property int count: server.trackedNotifications.values.length

  // When the notification arrived, in ms since the epoch, or 0 if unknown.
  function arrival(notification: var): real {
    return persist.arrivals[notification?.id] ?? 0
  }

  // Keyed by notification id. Kept across reloads, like the notifications.
  PersistentProperties {
    id: persist
    reloadableId: "notificationArrivals"

    property var arrivals: ({})
  }

  NotificationServer {
    id: server

    keepOnReload: true
    actionsSupported: true
    bodySupported: true
    bodyMarkupSupported: true
    imageSupported: true

    onNotification: notification => {
      notification.tracked = true
      // Record this arrival, dropping entries for notifications that are gone.
      const arrivals = {}
      for (const n of server.trackedNotifications.values) {
        arrivals[n.id] = persist.arrivals[n.id] ?? Date.now()
      }
      arrivals[notification.id] = Date.now()
      persist.arrivals = arrivals
    }
  }
}
