pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Polls /proc/meminfo and exposes used memory as a percentage.
Singleton {
  id: root

  property int usage: 0
  property int total: 0
  property int available: 0

  Process {
    id: proc
    command: ["cat", "/proc/meminfo"]
    running: true
    stdout: SplitParser {
      onRead: data => {
        var p = data.trim().split(/\s+/)
        if (p[0] === "MemTotal:") root.total = parseInt(p[1])
        else if (p[0] === "MemAvailable:") root.available = parseInt(p[1])
      }
    }
    onExited: {
      if (root.total > 0) root.usage = Math.round(100 * (1 - root.available / root.total))
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: proc.running = true
  }
}
