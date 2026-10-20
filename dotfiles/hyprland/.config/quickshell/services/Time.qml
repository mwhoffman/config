pragma Singleton
import Quickshell
import QtQuick

// Current date/time, updated once a minute.
Singleton {
  readonly property date date: clock.date

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}
