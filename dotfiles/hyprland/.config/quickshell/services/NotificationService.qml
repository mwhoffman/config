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

  // Arrival times keyed by notification id. Unreadable text (e.g. left by an
  // older version of this file) counts as no arrivals.
  readonly property var arrivals: {
    try {
      return JSON.parse(persist.arrivals) ?? {}
    } catch (e) {
      return {}
    }
  }

  // When the notification arrived, in ms since the epoch, or 0 if unknown.
  function arrival(notification: var): real {
    return arrivals[notification?.id] ?? 0
  }

  // Kept across reloads, like the notifications. Stored as JSON text because
  // a JS object can't be carried over to the reloaded config: it would be
  // lost, with a "JSValue can't be reassigned to another engine" warning.
  PersistentProperties {
    id: persist
    reloadableId: "notificationArrivals"

    property string arrivals: "{}"
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
        arrivals[n.id] = root.arrivals[n.id] ?? Date.now()
      }
      arrivals[notification.id] = Date.now()
      persist.arrivals = JSON.stringify(arrivals)
    }
  }
}
