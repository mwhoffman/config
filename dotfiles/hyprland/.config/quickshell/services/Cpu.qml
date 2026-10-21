pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Polls /proc/stat and exposes overall CPU usage as a percentage.
Singleton {
  id: root

  property int usage: 0
  property int lastIdle: 0
  property int lastTotal: 0

  Process {
    id: proc
    command: ["head", "-1", "/proc/stat"]
    running: true
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var p = data.trim().split(/\s+/)
        var idle = parseInt(p[4]) + parseInt(p[5])
        var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
        if (root.lastTotal > 0) {
          root.usage = Math.round(100 * (1 - (idle - root.lastIdle) / (total - root.lastTotal)))
        }
        root.lastTotal = total
        root.lastIdle = idle
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: proc.running = true
  }
}
