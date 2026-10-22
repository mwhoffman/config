pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.components
import qs.services
import qs.settings

// Password prompt for polkit requests (see PolkitService).
//
// Shown while a request is open, taking all keyboard input so the password
// can't be typed into another window. Enter or Authenticate submits; Escape
// or Cancel aborts. Clicking outside does nothing, since a cancel counts as a
// failed attempt toward the account lockout. The typed password only lives in
// the input field, which is cleared after every submit and whenever the
// prompt closes.
Dialog {
  id: root

  readonly property var flow: PolkitService.flow
  // Whether an attempt in this request has failed. Tracked here because
  // AuthFlow.failed doesn't update when an attempt fails.
  property bool failed: false
  // The latest prompt text (e.g. "Password: "). Polkit clears inputPrompt
  // while it checks a response; keeping the last one avoids the line
  // vanishing and the card jumping in size.
  property string prompt: ""
  // Whose password is being asked for (polkit's selected identity), as a
  // username; usually the current user.
  readonly property string identity: {
    const id = flow?.selectedIdentity
    return id ? id.string || id.displayName || String(id.id) : ""
  }
  // For pkexec, the command being run. Polkit only passes it inside the
  // message: "Authentication is needed to run `<command>' as the super user".
  readonly property string command: {
    if (flow?.actionId !== "org.freedesktop.policykit.exec") return ""
    return flow.message.match(/`([\s\S]*)'/)?.[1] ?? ""
  }

  function submit() {
    if (!flow?.isResponseRequired) return
    flow.submit(input.text)
    input.clear()
  }

  function cancel() {
    input.clear()
    flow?.cancelAuthenticationRequest()
  }

  name: "auth"
  open: PolkitService.active
  initialFocus: input
  closeOnClickOutside: false
  onAccepted: submit()
  onDismissed: cancel()

  onVisibleChanged: input.clear()

  onFlowChanged: {
    failed = false
    prompt = flow?.inputPrompt ?? ""
  }

  Connections {
    target: root.flow

    // Each new prompt (including the retry after a wrong password) starts empty.
    function onIsResponseRequiredChanged() {
      input.clear()
      if (root.flow.isResponseRequired) input.forceActiveFocus()
    }

    function onInputPromptChanged() {
      if (root.flow.inputPrompt) root.prompt = root.flow.inputPrompt
    }

    function onAuthenticationFailed() {
      root.failed = true
    }
  }

  // Plain text only (DialogText): the message and command come from the
  // requesting app, and rich text could be used to hide or disguise what is
  // being authorized.
  component PromptText: DialogText {
    Layout.fillWidth: true
    wrapMode: Text.Wrap
  }

  DialogTitle {
    glyph: Icons.lock
    text: "Authentication required"
  }

  Divider {}

  // Indented like the title, so the text lines up with its glyph.
  ColumnLayout {
    Layout.fillWidth: true
    Layout.leftMargin: Config.dialog.padding / 2
    Layout.rightMargin: Config.dialog.padding / 2
    spacing: 10

    PromptText {
      text: root.command
        ? `Authentication${root.identity ? ` as ${root.identity}` : ""} is required to run the following command:`
        : root.flow?.message ?? ""
    }

    PromptText {
      visible: root.command !== ""
      text: root.command
      color: Config.theme.text
      wrapMode: Text.WrapAnywhere
    }

    PromptText {
      // Only worth saying when it isn't the obvious "you", e.g. root. For
      // pkexec the identity is already part of the message above.
      visible: text !== ""
      text: root.command || !root.identity || root.identity === Quickshell.env("USER")
        ? ""
        : `Authenticating as ${root.identity}`
    }

    PromptText {
      visible: text !== ""
      text: root.prompt
    }

    Rectangle {
      Layout.fillWidth: true
      implicitHeight: input.implicitHeight + 16
      color: Config.theme.bg
      border { color: input.activeFocus ? Config.theme.focused : Config.theme.inactive; width: 2 }
      radius: 4

      TextInput {
        id: input
        anchors { fill: parent; margins: 8 }
        verticalAlignment: TextInput.AlignVCenter
        enabled: root.flow?.isResponseRequired ?? false
        echoMode: root.flow?.responseVisible ? TextInput.Normal : TextInput.Password
        color: Config.theme.text
        selectionColor: Config.theme.focused
        clip: true
        font { family: Config.fontFamily; pointSize: Config.dialog.fontSize }

        // Enter submits and Escape cancels, via the shared dialog keys.
        Keys.onPressed: event => event.accepted = root.handleKey(event, true)
      }
    }

    PromptText {
      readonly property bool isError: !!(root.flow?.supplementaryIsError || (root.failed && !root.flow?.supplementaryMessage))

      visible: text !== ""
      text: root.flow?.supplementaryMessage || (root.failed ? "Authentication failed, try again." : "")
      color: isError ? Config.theme.urgent : Config.theme.active
    }

    RowLayout {
      Layout.topMargin: 4
      spacing: 8

      Item { Layout.fillWidth: true }

      TextButton {
        text: "Cancel"
        font.pointSize: Config.dialog.fontSize
        onClicked: root.cancel()
      }

      TextButton {
        text: "Authenticate"
        font.pointSize: Config.dialog.fontSize
        primary: true
        enabled: root.flow?.isResponseRequired ?? false
        onClicked: root.submit()
      }
    }
  }
}
