//@ pragma UseQApplication

import Quickshell

ShellRoot {
  MediaKeys {}
  Notifications {}

  // One wallpaper and one bar per monitor.
  Variants {
    model: Quickshell.screens
    Wallpaper {}
  }

  Variants {
    model: Quickshell.screens
    Bar {}
  }
}
