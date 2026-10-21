import Quickshell
import Quickshell.Hyprland

import qs.services

// Hyprland global shortcuts for media control. Bind keys to them in
// hyprland.lua with hl.dsp.global("quickshell:<name>").
Scope {
  // Singletons are created on first use, and MediaService needs a moment to
  // find the players. Use it now so the first key press after a (re)load
  // isn't lost.
  readonly property var player: MediaService.player

  GlobalShortcut {
    name: "mediaPlayPause"
    description: "Play/pause the active media player"
    onPressed: MediaService.playPause()
  }

  GlobalShortcut {
    name: "mediaNext"
    description: "Next track on the active media player"
    onPressed: MediaService.next()
  }

  GlobalShortcut {
    name: "mediaPrevious"
    description: "Previous track on the active media player"
    onPressed: MediaService.previous()
  }
}
