pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Shell settings with defaults given below that can be overridden by
// ~/.quickshell.json. The override file has the same shape and only needs the
// keys it changes. Unknown keys, wrong types and malformed colors are logged as
// warnings and ignored.
Singleton {
  id: root

  readonly property var defaults: ({
    // Image path, with a leading ~ expanded. "" shows theme.bg.
    wallpaper: "",
    fontFamily: "JetBrainsMono Nerd Font",
    // Hex colors: #rgb, #rrggbb or #aarrggbb.
    theme: {
      bg: "#1d2021",
      focused: "#458588",
      inactive: "#504945",
      active: "#928374",
      text: "#ebdbb2",
      urgent: "#fb4934",
      backdrop: "#99000000",  // dims the screen behind dialogs
    },
    bar: {
      height: 35,
      fontSize: 16,
      spacing: 24,      // between widgets
      iconSize: 18,
      traySpacing: 8,   // between tray icons
    },
    menu: {
      fontSize: 12,
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
  })

  // Defaults merged with the override file.
  property var values: defaults

  readonly property string wallpaper: values.wallpaper.replace(/^~(?=\/|$)/, Quickshell.env("HOME"))
  readonly property string fontFamily: values.fontFamily
  readonly property var theme: values.theme
  readonly property var bar: values.bar
  readonly property var menu: values.menu
  readonly property var notifications: values.notifications
  readonly property var dialog: values.dialog
  readonly property var power: values.power

  readonly property string path: Quickshell.env("HOME") + "/.quickshell.json"

  function warn(message) {
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

  // Returns `base` with `override` applied, warning about (and skipping) any
  // override that doesn't match the shape and types of `base`.
  function merge(base, override, prefix) {
    const result = Object.assign({}, base)
    for (const key in override) {
      const name = prefix + key
      const fallback = base[key]
      const value = override[key]
      if (!(key in base)) {
        warn(`unknown key "${name}"`)
      } else if (isObject(fallback)) {
        if (isObject(value)) result[key] = merge(fallback, value, name + ".")
        else warn(`"${name}" should be an object, got ${describe(value)}`)
      } else if (isObject(value) || typeof value !== typeof fallback) {
        warn(`"${name}" should be a ${typeof fallback}, got ${describe(value)}`)
      } else if (prefix === "theme." && !/^#([0-9a-f]{3}|[0-9a-f]{6}|[0-9a-f]{8})$/i.test(value)) {
        warn(`"${name}" should be a hex color, got ${describe(value)}`)
      } else {
        result[key] = value
      }
    }
    return result
  }

  function apply(text) {
    let parsed
    try {
      parsed = JSON.parse(text)
    } catch (e) {
      warn(`invalid JSON, using defaults: ${e.message}`)
      values = defaults
      return
    }
    if (!isObject(parsed)) {
      warn(`expected an object at the top level, got ${describe(parsed)}`)
      values = defaults
      return
    }
    values = merge(defaults, parsed, "")
  }

  FileView {
    id: file

    property bool found: false

    path: root.path
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onLoaded: {
      found = true
      root.apply(text())
    }
    onLoadFailed: error => {
      found = false
      if (error !== FileViewError.FileNotFound) root.warn(`can't read: ${FileViewError.toString(error)}`)
      root.values = root.defaults
    }
  }

  // A missing file can't be watched, so check for it now and then.
  Timer {
    interval: 5000
    repeat: true
    running: !file.found
    onTriggered: file.reload()
  }
}
