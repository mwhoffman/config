pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Shell settings with defaults given below, overridden by two optional files,
// each applied on top of the last:
//
// - config.json next to shell.qml (~/.config/quickshell/config.json): shared
//   settings such as the theme, which can live in the dotfiles repo.
// - ~/.quickshell.json: settings for this machine, such as the wallpaper.
//
// Both have the same shape as the defaults and only need the keys they change.
// Unknown keys, wrong types and malformed colors are logged as warnings and
// ignored. Changes to either file, including creating or deleting it, apply
// without a restart.
Singleton {
  id: root

  readonly property var defaults: ({
    // Image path, with a leading ~ expanded. "" shows theme.bg.
    wallpaper: "",
    fontFamily: "JetBrainsMono Nerd Font",
    // Hex colors: #rgb, #rrggbb or #aarrggbb. These match the theme's ui roles
    // (and tmux's colors): a fill and the text on it are e.g. active and
    // activeText. HyprlandTheme.qml also applies focused, border and shadow to
    // Hyprland's windows.
    theme: {
      bg: "#1d2021",
      text: "#ebdbb2",
      dim: "#928374",           // secondary text: the bar's status, dialog text
      disabled: "#504945",      // placeholders, hints, things switched off
      focused: "#458588",       // focused workspace and window border; primary
      focusedText: "#ebdbb2",   // and hovered buttons; switches
      active: "#a89984",        // focused input borders; dialog and menu
      activeText: "#282828",    // borders
      inactive: "#504945",      // other workspaces, and buttons
      inactiveText: "#a89984",
      border: "#504945",        // other windows' borders, and dividers
      selection: "#665c54",     // selected text in inputs, behind its own color
      current: "#504945",       // the current row of a dialog or menu
      currentText: "#ebdbb2",
      alert: "#fb4934",         // lines and text: critical notifications, errors
      alertFill: "#cc241d",     // filled backgrounds: urgent workspaces
      alertFillText: "#ebdbb2",
      backdrop: "#99000000",    // dims the screen behind dialogs
      shadow: "#ee1d2021",      // window shadows, dark whatever the theme
    },
    bar: {
      position: "bottom", // "top" or "bottom" of the screen
      height: 36,         // even, so even-height widgets center exactly
      fontSize: 16,
      spacing: 18,      // between widgets, and tray icons
      iconSize: 18,
      statusIconSize: 24, // drawn icons: volume, and the line crossing icons out
      workspaceSpacing: 4,
      workspaceRadius: 4,
    },
    menu: {
      fontSize: 12,
      switchScale: 0.6,   // size of on/off switches (Qt's are 56x28 at 1)
      padding: 6,
      radius: 8,
      offset: 12,       // extra drop below the tray icon so menus clear the bar
    },
    notifications: {
      width: 380,
      fontSize: 12,
      titleFontSize: 16,
      iconSize: 32,
      padding: 10,
      radius: 8,
      border: 2,
      spacing: 8,       // between popups
      margin: 12,       // from the screen edge and bar
      timeout: 5000,    // ms, when the app doesn't set one
    },
    // Centered dialogs: the auth prompt and power menu.
    dialog: {
      width: 420,
      fontSize: 14,
      titleFontSize: 16,
      padding: 16,
      radius: 8,
    },
    // Shell commands run by the power menu.
    power: {
      logout: "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'",
      reboot: "systemctl reboot",
      shutdown: "systemctl poweroff",
    },
    launcher: {
      rows: 8,          // visible results; more scroll
      iconSize: 24,
      hintFontSize: 12,   // generic names ("Web Browser") beside app names
      terminal: "ghostty",  // runs apps that need a terminal: <terminal> -e <command>
    },
    lock: {
      clockFontSize: 72,
      dateFontSize: 18,
      clockMargin: 48,    // between the date and the password card
      hideAfter: 15000,   // ms without activity before the card hides
    },
  })

  // The defaults with config.json, then ~/.quickshell.json, applied on top.
  readonly property var values: overlay(overlay(defaults, shared.settings), local.settings)

  readonly property string wallpaper: values.wallpaper.replace(/^~(?=\/|$)/, Quickshell.env("HOME"))
  readonly property string fontFamily: values.fontFamily
  readonly property var theme: values.theme
  readonly property var bar: values.bar
  readonly property var menu: values.menu
  readonly property var notifications: values.notifications
  readonly property var dialog: values.dialog
  readonly property var power: values.power
  readonly property var launcher: values.launcher
  readonly property var lock: values.lock

  function warn(path, message) {
    console.warn(`Config (${path}): ${message}`)
  }

  function isObject(value) {
    return value !== null && typeof value === "object" && !Array.isArray(value)
  }

  function describe(value) {
    if (value === null) return "null"
    if (Array.isArray(value)) return "an array"
    if (isObject(value)) return "an object"
    return `${typeof value} ${JSON.stringify(value)}`
  }

  // The valid part of `override`: only keys that `base` has, with the same
  // shape and type. Warns about (and drops) the rest.
  function validate(base, override, prefix, path) {
    const result = {}
    for (const key in override) {
      const name = prefix + key
      const fallback = base[key]
      const value = override[key]
      if (!(key in base)) {
        warn(path, `unknown key "${name}"`)
      } else if (isObject(fallback)) {
        if (isObject(value)) result[key] = validate(fallback, value, name + ".", path)
        else warn(path, `"${name}" should be an object, got ${describe(value)}`)
      } else if (isObject(value) || typeof value !== typeof fallback) {
        warn(path, `"${name}" should be a ${typeof fallback}, got ${describe(value)}`)
      } else if (prefix === "theme." && !/^#([0-9a-f]{3}|[0-9a-f]{6}|[0-9a-f]{8})$/i.test(value)) {
        warn(path, `"${name}" should be a hex color, got ${describe(value)}`)
      } else {
        result[key] = value
      }
    }
    return result
  }

  // `base` with an already validated `override` applied on top.
  function overlay(base, override) {
    const result = Object.assign({}, base)
    for (const key in override) {
      result[key] = isObject(base[key]) ? overlay(base[key], override[key]) : override[key]
    }
    return result
  }

  // A settings file's validated contents, or {} if it isn't usable.
  function parse(text, path) {
    let parsed
    try {
      parsed = JSON.parse(text)
    } catch (e) {
      warn(path, `invalid JSON, ignoring this file: ${e.message}`)
      return {}
    }
    if (!isObject(parsed)) {
      warn(path, `expected an object at the top level, got ${describe(parsed)}, ignoring this file`)
      return {}
    }
    return validate(defaults, parsed, "", path)
  }

  function loaded(file) {
    file.found = true
    file.settings = parse(file.text(), file.path)
  }

  function loadFailed(file, error) {
    file.found = false
    if (error !== FileViewError.FileNotFound) warn(file.path, `can't read: ${FileViewError.toString(error)}`)
    file.settings = {}
  }

  // Each file's validated settings are in `settings`: {} while it's missing.
  FileView {
    id: shared

    property var settings: ({})
    property bool found: false

    path: Quickshell.shellPath("config.json")
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onLoaded: root.loaded(shared)
    onLoadFailed: error => root.loadFailed(shared, error)
  }

  FileView {
    id: local

    property var settings: ({})
    property bool found: false

    path: Quickshell.env("HOME") + "/.quickshell.json"
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onLoaded: root.loaded(local)
    onLoadFailed: error => root.loadFailed(local, error)
  }

  // A missing file can't be watched, so check for it now and then.
  Timer {
    interval: 5000
    repeat: true
    running: !shared.found || !local.found
    onTriggered: {
      if (!shared.found) shared.reload()
      if (!local.found) local.reload()
    }
  }
}
