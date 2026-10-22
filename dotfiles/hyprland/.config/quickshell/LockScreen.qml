pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import qs.components
import qs.services
import qs.settings

// Lock screen, shown while LockService.locked.
//
// Every monitor shows the blurred, dimmed wallpaper with a clock. Any key
// press or mouse movement reveals the password card on the focused monitor,
// and typing goes straight into it. It hides again, cleared, after
// Config.lock.hideAfter ms without activity, or on Escape. Enter checks the
// password; only that counts toward the failed-attempt lockout.
Scope {
  id: root

  // Whether the password card is showing.
  property bool revealed: false

  function activity() {
    revealed = true
    hideTimer.restart()
  }

  Timer {
    id: hideTimer
    interval: Config.lock.hideAfter
    onTriggered: if (!LockService.checking) root.revealed = false
  }

  // Count the end of a check as activity, so a result stays readable.
  Connections {
    target: LockService
    function onCheckingChanged() {
      if (!LockService.checking) hideTimer.restart()
    }
  }

  // Only the surface goes inside: any object here becomes WlSessionLock's
  // (single) surface, so the timer and connections above live outside it.
  WlSessionLock {
    locked: LockService.locked
    onLockedChanged: root.revealed = false

    WlSessionLockSurface {
      id: surface

      // Whether this monitor shows the password card. Errs towards showing it,
      // so a missing name can never leave the card hidden everywhere.
      readonly property bool focused: !Hyprland.focusedMonitor || !screen?.name
        || Hyprland.focusedMonitor.name === screen.name

      color: Config.theme.bg

      Component.onCompleted: input.forceActiveFocus()

      Image {
        id: wallpaper
        anchors.fill: parent
        visible: false
        source: Config.wallpaper ? "file://" + Config.wallpaper : ""
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        sourceSize { width: surface.width; height: surface.height }
      }

      MultiEffect {
        anchors.fill: parent
        visible: wallpaper.status === Image.Ready
        source: wallpaper
        autoPaddingEnabled: false
        blurEnabled: true
        blur: 1.0
        blurMax: 64
      }

      Rectangle {
        anchors.fill: parent
        color: Config.theme.backdrop
      }

      // Reveals the card on real pointer movement. The surface gets a position
      // event as soon as it appears under the cursor, so the first position is
      // only remembered, and the card shows once the pointer moves away from it.
      MouseArea {
        property point start: Qt.point(-1, -1)

        anchors.fill: parent
        hoverEnabled: true

        onPositionChanged: mouse => {
          if (start.x < 0) {
            start = Qt.point(mouse.x, mouse.y)
          } else if (Math.abs(mouse.x - start.x) + Math.abs(mouse.y - start.y) > 8) {
            start = Qt.point(mouse.x, mouse.y)
            root.activity()
          }
        }
        onClicked: root.activity()
      }

      ColumnLayout {
        anchors { horizontalCenter: parent.horizontalCenter; bottom: card.top; bottomMargin: Config.lock.clockMargin }
        spacing: 0

        DialogText {
          Layout.alignment: Qt.AlignHCenter
          text: Qt.formatDateTime(TimeService.date, "HH:mm")
          color: Config.theme.text
          font.pointSize: Config.lock.clockFontSize
        }

        DialogText {
          Layout.alignment: Qt.AlignHCenter
          text: Qt.formatDateTime(TimeService.date, "dddd, d MMMM")
          font.pointSize: Config.lock.dateFontSize
        }
      }

      // Styled like a Dialog card. Hidden with opacity rather than visibility
      // so the field keeps keyboard focus and typing reveals it.
      Rectangle {
        id: card

        anchors.centerIn: parent
        width: Config.dialog.width
        implicitHeight: content.implicitHeight + 2 * Config.dialog.padding
        opacity: root.revealed && surface.focused ? 1 : 0
        color: Config.theme.bg
        border { color: Config.theme.inactive; width: 2 }
        radius: Config.dialog.radius

        Behavior on opacity {
          NumberAnimation { duration: 150 }
        }

        ColumnLayout {
          id: content
          anchors { fill: parent; margins: Config.dialog.padding }
          spacing: 10

          DialogTitle {
            glyph: Icons.lock
            text: Quickshell.env("USER")
          }

          Divider {}

          ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: Config.dialog.padding / 2
            Layout.rightMargin: Config.dialog.padding / 2
            spacing: 10

            Rectangle {
              Layout.fillWidth: true
              implicitHeight: input.implicitHeight + 16
              color: Config.theme.bg
              border { color: LockService.checking ? Config.theme.inactive : Config.theme.focused; width: 2 }
              radius: 4

              TextInput {
                id: input

                anchors { fill: parent; margins: 8 }
                verticalAlignment: TextInput.AlignVCenter
                echoMode: TextInput.Password
                readOnly: LockService.checking
                color: Config.theme.text
                selectionColor: Config.theme.focused
                clip: true
                font { family: Config.fontFamily; pointSize: Config.dialog.fontSize }

                Keys.onPressed: event => {
                  root.activity()
                  if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    LockService.unlock(text)
                    clear()
                    event.accepted = true
                  } else if (event.key === Qt.Key_Escape && !LockService.checking) {
                    clear()
                    root.revealed = false
                    hideTimer.stop()
                    event.accepted = true
                  }
                }

                DialogText {
                  anchors.verticalCenter: parent.verticalCenter
                  visible: input.text === ""
                  text: LockService.checking ? "Checking…" : "Password"
                  color: Config.theme.inactive
                }

                // Hiding the card discards anything half typed.
                Connections {
                  target: root
                  function onRevealedChanged() {
                    if (!root.revealed) input.clear()
                  }
                }
              }
            }

            DialogText {
              Layout.fillWidth: true
              visible: text !== ""
              text: LockService.message
              wrapMode: Text.Wrap
              color: LockService.messageIsError ? Config.theme.urgent : Config.theme.active
            }
          }
        }
      }
    }
  }
}
