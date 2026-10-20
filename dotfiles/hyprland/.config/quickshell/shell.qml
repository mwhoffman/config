//@ pragma UseQApplication
import Quickshell
import qs.bar

ShellRoot {
  MediaKeys {}

  // One bar per monitor.
  Variants {
    model: Quickshell.screens
    Bar {}
  }
}
