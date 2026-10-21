pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import qs.components
import qs.services
import qs.settings

// Password prompt for polkit requests (see PolkitService).
//
// Dims the focused monitor and takes all keyboard input while a request is
// open, so the password can't be typed into another window. Enter submits,
// Escape or Cancel aborts. The typed password only lives in the input field,
// which is cleared after every submit and whenever the prompt closes.
PanelWindow {
  id: root

  readonly property var flow: PolkitService.flow
  // Whether an attempt in this request has failed. Tracked here because
  // AuthFlow.failed doesn't update when an attempt fails.
  property bool failed: false
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

  screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0]
  visible: PolkitService.active

  anchors { top: true; bottom: true; left: true; right: true }
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "quickshell:auth"
  WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
  color: Config.theme.backdrop

  onVisibleChanged: {
    input.clear()
    if (visible) input.forceActiveFocus()
  }

  onFlowChanged: failed = false

  Connections {
    target: root.flow

    // Each new prompt (including the retry after a wrong password) starts empty.
    function onIsResponseRequiredChanged() {
      input.clear()
      if (root.flow.isResponseRequired) input.forceActiveFocus()
    }

    function onAuthenticationFailed() {
      root.failed = true
    }
  }

  // Plain text only: the message and command come from the requesting app,
  // and rich text could be used to hide or disguise what is being authorized.
  component PromptText: Text {
    Layout.fillWidth: true
    textFormat: Text.PlainText
    color: Config.theme.active
    wrapMode: Text.Wrap
    font { family: Config.fontFamily; pointSize: Config.auth.fontSize }
  }

  Rectangle {
    anchors.centerIn: parent
    width: Config.auth.width
    implicitHeight: content.implicitHeight + 2 * Config.auth.padding
    color: Config.theme.bg
    border { color: Config.theme.inactive; width: 2 }
    radius: Config.auth.radius

    ColumnLayout {
      id: content
      anchors { fill: parent; margins: Config.auth.padding }
      spacing: 10

      RowLayout {
        spacing: 10

        PromptText {
          Layout.fillWidth: false
          text: Icons.lock
          color: Config.theme.text
          font.pointSize: Config.auth.titleFontSize
        }

        PromptText {
          text: "Authentication required"
          color: Config.theme.text
          font { bold: true; pointSize: Config.auth.titleFontSize }
        }
      }

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
        text: root.flow?.inputPrompt ?? ""
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
          font { family: Config.fontFamily; pointSize: Config.auth.fontSize }

          onAccepted: root.submit()
          Keys.onEscapePressed: root.cancel()
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
          font.pointSize: Config.auth.fontSize
          onClicked: root.cancel()
        }

        TextButton {
          text: "Authenticate"
          font.pointSize: Config.auth.fontSize
          primary: true
          enabled: root.flow?.isResponseRequired ?? false
          onClicked: root.submit()
        }
      }
    }
  }
}
