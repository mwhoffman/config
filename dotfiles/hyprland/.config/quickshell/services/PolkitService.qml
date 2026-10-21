pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Polkit

// Polkit authentication agent: when an app asks for a privileged action (e.g.
// `pkexec`), polkit asks this agent to authenticate the user. AuthPrompt.qml
// shows the request in `flow`.
//
// Only one agent can be registered per session, so don't also run
// hyprpolkitagent or similar.
Singleton {
  id: root

  // True while a request is being shown; `flow` is null otherwise.
  readonly property bool active: agent.isActive
  readonly property AuthFlow flow: agent.flow

  PolkitAgent {
    id: agent

    onIsRegisteredChanged: {
      if (isRegistered) console.info("Polkit agent registered")
      else console.warn("Polkit agent not registered; is another agent running?")
    }
  }
}
