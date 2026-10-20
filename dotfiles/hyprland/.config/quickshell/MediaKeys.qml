import Quickshell
import Quickshell.Hyprland
import qs.services

// Hyprland global shortcuts for media control. Bind keys to them in
// hyprland.lua with hl.dsp.global("quickshell:<name>").
Scope {
  GlobalShortcut {
    name: "mediaPlayPause"
    description: "Play/pause the active media player"
    onPressed: Media.playPause()
  }

  GlobalShortcut {
    name: "mediaNext"
    description: "Next track on the active media player"
    onPressed: Media.next()
  }

  GlobalShortcut {
    name: "mediaPrevious"
    description: "Previous track on the active media player"
    onPressed: Media.previous()
  }
}
