pragma Singleton

import QtQuick
import Quickshell

// Current date/time, updated once a minute.
Singleton {
  readonly property date date: clock.date

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}
