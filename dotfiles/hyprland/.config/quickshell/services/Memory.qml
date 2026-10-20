pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// Polls /proc/meminfo and exposes used memory as a percentage.
Singleton {
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
        if (p[0] === "MemTotal:") total = parseInt(p[1])
        else if (p[0] === "MemAvailable:") available = parseInt(p[1])
      }
    }
    onExited: {
      if (total > 0) usage = Math.round(100 * (1 - available / total))
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: proc.running = true
  }
}
