//@ pragma UseQApplication

import Quickshell

ShellRoot {
  AuthPrompt {}
  Launcher {}
  LockScreen {}
  MediaKeys {}
  Notifications {}
  PowerMenu {}

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
