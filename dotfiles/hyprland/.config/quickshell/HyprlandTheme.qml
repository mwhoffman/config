import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

import qs.settings

// Applies the theme to Hyprland: window borders (theme.focused for the focused
// window and theme.border for the others) and shadows (theme.shadow).
// Hyprland's own config (look_and_feel.lua) has matching fallbacks, shown until
// Quickshell starts.
// A Hyprland config reload resets them, so they're re-applied after each one.
Scope {
  id: root

  // The Lua that sets the colors. Changes whenever the theme does.
  readonly property string lua: {
    const t = Config.theme
    return `hl.config({
      general = { col = { active_border = "${hyprColor(t.focused)}", inactive_border = "${hyprColor(t.border)}" } },
      decoration = { shadow = { color = "${hyprColor(t.shadow)}" } },
    })`
  }

  // The Lua being (or last) sent.
  property string sent: ""

  // A theme color (#rgb, #rrggbb or #aarrggbb, already checked by Config) as
  // aarrggbb digits.
  function argb(hex: string): string {
    let digits = hex.slice(1).toLowerCase()
    if (digits.length === 3) digits = digits.split("").map(c => c + c).join("")
    return digits.length === 6 ? "ff" + digits : digits
  }

  // Hyprland's rgba(rrggbbaa) form of a theme color: the alpha moves to the end.
  function hyprColor(hex: string): string {
    const digits = argb(hex)
    return `rgba(${digits.slice(2)}${digits.slice(0, 2)})`
  }

  function apply() {
    if (evalProcess.running) return  // onExited sends the latest
    sent = lua
    evalProcess.running = true
  }

  onLuaChanged: apply()
  Component.onCompleted: apply()

  Connections {
    target: Hyprland

    function onRawEvent(event) {
      if (event.name === "configreloaded") root.apply()
    }
  }

  Process {
    id: evalProcess

    command: ["hyprctl", "eval", root.sent]
    stdout: StdioCollector {
      id: output
    }
    onExited: code => {
      if (code !== 0) console.warn("HyprlandTheme: hyprctl eval failed:", output.text.trim())
      // The theme changed while this was running.
      if (root.sent !== root.lua) root.apply()
    }
  }
}
