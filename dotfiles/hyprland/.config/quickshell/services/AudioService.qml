pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

// The default output's volume and mute state, updated by PipeWire events,
// plus the list of outputs to choose the default from.
Singleton {
  id: root

  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property int volume: Math.round((sink?.audio?.volume ?? 0) * 100)
  readonly property bool muted: sink?.audio?.muted ?? false

  // Audio outputs (devices, not app streams), by name.
  readonly property var sinks: Array.from(Pipewire.nodes.values)
    .filter(node => node.isSink && !node.isStream)
    .sort((a, b) => label(a).localeCompare(label(b)))

  function label(node: var): string {
    return node.description || node.nickname || node.name
  }

  // Makes `node` the default output, as `wpctl set-default` does; playing
  // streams follow it.
  function setDefault(node: var) {
    Pipewire.preferredDefaultAudioSink = node
  }

  // Node properties only stay live while the node is tracked.
  PwObjectTracker {
    objects: [root.sink]
  }
}
