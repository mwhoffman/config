//@ pragma UseQApplication
import Quickshell
import qs.bar

ShellRoot {
  // One bar per monitor.
  Variants {
    model: Quickshell.screens
    Bar {}
  }
}
