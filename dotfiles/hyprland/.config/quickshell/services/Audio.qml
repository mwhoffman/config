pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

// Volume and mute state of the default output, updated by PipeWire events.
Singleton {
  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property int volume: Math.round((sink?.audio?.volume ?? 0) * 100)
  readonly property bool muted: sink?.audio?.muted ?? false

  // Node properties only stay live while the node is tracked.
  PwObjectTracker {
    objects: [sink]
  }
}
