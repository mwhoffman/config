pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import qs.components
import qs.settings

// App launcher: lists installed applications (.desktop entries) and filters
// them as you type.
//
// Toggled by the quickshell:launcher shortcut (bound in hyprland.lua). Uses
// the shared dialog keys (see Dialog), without plain j/k since you type here;
// Enter launches the selected app, which is the best match.
Dialog {
  id: root

  property int selected: 0
  readonly property var results: search(input.text)

  // Visible apps matching the query, best match first; all of them, sorted
  // by name, when the query is empty.
  function search(query: string): var {
    const apps = DesktopEntries.applications.values.filter(app => !app.noDisplay)
    const q = query.trim().toLowerCase()
    if (!q) return apps.sort((a, b) => a.name.localeCompare(b.name))
    return apps
      .map(app => ({ app, score: score(app, q) }))
      .filter(match => match.score > 0)
      .sort((a, b) => b.score - a.score || a.app.name.localeCompare(b.app.name))
      .map(match => match.app)
  }

  // 4: the name starts with the query; 3: a word in the name does; 2: the
  // name, generic name or keywords contain it; 1: its letters appear in the
  // name in order; 0: no match.
  function score(app: var, q: string): int {
    const name = app.name.toLowerCase()
    if (name.startsWith(q)) return 4
    if (name.split(/[\s\-_.]+/).some(word => word.startsWith(q))) return 3
    const other = [app.genericName, ...Array.from(app.keywords)].join(" ").toLowerCase()
    if (name.includes(q) || other.includes(q)) return 2
    let i = 0
    for (const c of name) {
      if (c === q[i]) i++
    }
    return i === q.length ? 1 : 0
  }

  function launch(app: var) {
    open = false
    if (!app) return
    if (app.runInTerminal) Quickshell.execDetached([Config.launcher.terminal, "-e", ...Array.from(app.command)])
    else app.execute()
  }

  function move(step: int) {
    if (results.length > 0) selected = (selected + step + results.length) % results.length
  }

  name: "launcher"
  initialFocus: input
  onMoved: step => move(step)
  onAccepted: launch(results[selected])
  onDismissed: open = false
  // Start fresh each time it opens.
  onOpenChanged: {
    input.clear()
    selected = 0
  }
  onSelectedChanged: list.positionViewAtIndex(selected, ListView.Contain)

  GlobalShortcut {
    name: "launcher"
    description: "Open or close the app launcher"
    onPressed: root.open = !root.open
  }

  // Search field, indented and with its glyph centered in the icon column so
  // it lines up with the rows below.
  RowLayout {
    Layout.leftMargin: Config.dialog.padding / 2
    Layout.rightMargin: Config.dialog.padding / 2
    spacing: 10

    DialogText {
      Layout.preferredWidth: Config.launcher.iconSize
      horizontalAlignment: Text.AlignHCenter
      text: Icons.search
      color: Config.theme.text
      font.pointSize: Config.dialog.titleFontSize
    }

    TextInput {
      id: input

      Layout.fillWidth: true
      color: Config.theme.text
      selectionColor: Config.theme.focused
      selectByMouse: true
      clip: true
      font { family: Config.fontFamily; pointSize: Config.dialog.titleFontSize }

      onTextChanged: root.selected = 0

      Keys.onPressed: event => event.accepted = root.handleKey(event, true)

      DialogText {
        anchors.verticalCenter: parent.verticalCenter
        visible: input.text === ""
        text: "Search apps"
        color: Config.theme.inactive
        font.pointSize: Config.dialog.titleFontSize
      }
    }
  }

  Divider {}

  ListView {
    id: list

    // A fixed height of `rows` rows, so the card doesn't resize while typing.
    Layout.fillWidth: true
    Layout.preferredHeight: Config.launcher.rows * (rowSize.implicitHeight + spacing) - spacing
    clip: true
    spacing: 2
    boundsBehavior: Flickable.StopAtBounds
    model: root.results

    delegate: DialogRow {
      required property var modelData
      required property int index

      width: ListView.view.width
      current: root.selected === index
      iconWidth: Config.launcher.iconSize
      image: Quickshell.iconPath(modelData.icon, true)
      glyph: Icons.app
      label: modelData.name
      hint: modelData.genericName
      onHovered: root.selected = index
      onClicked: root.launch(modelData)
    }

    DialogText {
      anchors.centerIn: parent
      visible: list.count === 0
      text: "No matching apps"
    }
  }

  // Never shown; measures a row for the list's height.
  DialogRow {
    id: rowSize
    visible: false
    iconWidth: Config.launcher.iconSize
    label: " "
  }
}
