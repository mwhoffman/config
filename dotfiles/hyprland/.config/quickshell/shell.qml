//@ pragma UseQApplication
import Quickshell
import qs.bar

ShellRoot {
  MediaKeys {}

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
