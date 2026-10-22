pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pam

// Screen lock state and password checking (LockScreen.qml draws it).
//
// Passwords are checked with the system "login" PAM rules, so the same
// failed-attempt lockout applies as for a console login. A check only starts
// when a password is submitted, never when the prompt is merely shown or
// hidden, so hiding the prompt never counts as a failed attempt.
//
// Also lockable from outside with `qs ipc call lock lock`.
Singleton {
  id: root

  readonly property bool locked: state.locked
  // True while a password is being checked.
  readonly property bool checking: pam.active
  // The latest result or PAM message to show, e.g. "Wrong password" or an
  // account lockout notice.
  property string message: ""
  property bool messageIsError: false

  // The submitted password, held only until PAM asks for it.
  property string pending: ""

  function lock() {
    message = ""
    state.locked = true
  }

  function unlock(password: string) {
    if (!locked || pam.active || password === "") return
    message = ""
    pending = password
    if (!pam.start()) {
      pending = ""
      message = "Couldn't start the password check"
      messageIsError = true
    }
  }

  // Kept across reloads: a reload must never unlock the screen.
  PersistentProperties {
    id: state
    reloadableId: "lockState"

    property bool locked: false
  }

  PamContext {
    id: pam
    config: "login"

    onResponseRequiredChanged: {
      if (!responseRequired) return
      respond(root.pending)
      root.pending = ""
    }

    // Informational or error messages, e.g. pam_faillock's lockout notice.
    onPamMessage: {
      if (responseRequired || !message) return
      root.message = message
      root.messageIsError = messageIsError
    }

    onCompleted: result => {
      root.pending = ""
      if (result === PamResult.Success) {
        root.message = ""
        state.locked = false
      } else if (!root.message) {
        root.message = result === PamResult.MaxTries ? "Too many attempts" : "Wrong password"
        root.messageIsError = true
      }
    }
  }

  IpcHandler {
    target: "lock"

    function lock(): void {
      root.lock()
    }
  }
}
