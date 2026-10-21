pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

// Volume and mute state of the default output, updated by PipeWire events.
Singleton {
  id: root

  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property int volume: Math.round((sink?.audio?.volume ?? 0) * 100)
  readonly property bool muted: sink?.audio?.muted ?? false

  // Node properties only stay live while the node is tracked.
  PwObjectTracker {
    objects: [root.sink]
  }
}
