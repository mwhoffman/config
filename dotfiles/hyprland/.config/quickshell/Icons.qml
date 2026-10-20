pragma Singleton
import Quickshell
import QtQuick

// Nerd Font glyphs, written as escapes so they survive copy/paste.
// Look up codepoints at https://www.nerdfonts.com/cheat-sheet
Singleton {
  readonly property string cpu: " "       // nf-oct-cpu
  readonly property string memory: " "    // nf-fa-memory
  readonly property string clock: " "     // nf-fa-clock
  readonly property string volume: " "    // nf-fa-volume

  // Menu glyphs (components/MenuItem.qml).
  readonly property string checkboxOn: "\u{f0132}"   // nf-md-checkbox_marked
  readonly property string checkboxOff: "\u{f0131}"  // nf-md-checkbox_blank_outline
  readonly property string radioOn: "\u{f043e}"      // nf-md-radiobox_marked
  readonly property string radioOff: "\u{f043d}"     // nf-md-radiobox_blank
  readonly property string submenu: "\u{f0142}"      // nf-md-chevron_right

  // Tray icon overrides, keyed by the start of the tray item's id
  // (some apps append a number that can change between runs).
  readonly property var tray: ({
    "1Password_status_icon": "\u{f0881}",  // nf-md-onepassword
    "spotify-client": "\u{f04c7}",         // nf-md-spotify
  })

  // Returns the override glyph for a tray item id, or "" if none.
  function trayIcon(id: string): string {
    for (const prefix in tray) {
      if (id.startsWith(prefix)) return tray[prefix]
    }
    return ""
  }
}
