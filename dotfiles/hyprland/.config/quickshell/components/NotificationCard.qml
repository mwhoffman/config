pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets

import qs.services
import qs.settings

// One notification: icon, app name and arrival time, title (summary), body
// and action buttons.
//
// It expires after a timeout (the app's, or Config.notifications.timeout),
// paused while hovered; critical ones stay until clicked. Clicking it runs the
// app's default action if it has one, otherwise dismisses it.
Rectangle {
  id: card

  required property Notification notification

  // The notification is deleted just before this card, so bindings use ?.
  readonly property bool critical: notification?.urgency === NotificationUrgency.Critical
  readonly property var actions: Array.from(notification?.actions ?? [])
  readonly property var defaultAction: actions.find(a => a.identifier === "default") ?? null
  readonly property var buttons: actions.filter(a => a.identifier !== "default")

  // Image or app icon as a URL; app icons may be a path, a URL or a theme name.
  readonly property string iconSource: {
    if (notification?.image) return notification.image
    const icon = notification?.appIcon
    if (!icon) return ""
    if (icon.startsWith("/")) return "file://" + icon
    if (icon.includes("://")) return icon
    return Quickshell.iconPath(icon, true)
  }

  // Vanish once the notification is gone rather than collapsing to an empty
  // bordered box for the moment before the list removes this card.
  visible: notification !== null
  implicitHeight: visible ? content.implicitHeight + 2 * Config.notifications.padding : 0
  color: Config.theme.bg
  border { color: critical ? Config.theme.urgent : Config.theme.inactive; width: Config.notifications.border }
  radius: Config.notifications.radius

  // Dim by default; the title is the one bright line.
  component CardText: Text {
    Layout.fillWidth: true
    color: Config.theme.active
    wrapMode: Text.Wrap
    font { family: Config.fontFamily; pointSize: Config.notifications.fontSize }
  }

  Timer {
    // expireTimeout is in ms; 0 or less means "use the default".
    interval: card.notification?.expireTimeout > 0
      ? card.notification.expireTimeout
      : Config.notifications.timeout
    running: !card.critical && !hover.hovered
    onTriggered: card.notification.expire()
  }

  HoverHandler {
    id: hover
  }

  // Below the content, so action buttons get their own clicks.
  MouseArea {
    anchors.fill: parent
    onClicked: {
      if (card.defaultAction) card.defaultAction.invoke()
      else card.notification.dismiss()
    }
  }

  RowLayout {
    id: content
    anchors { fill: parent; margins: Config.notifications.padding }
    spacing: Config.notifications.padding

    IconImage {
      Layout.alignment: Qt.AlignTop
      visible: card.iconSource !== ""
      implicitSize: Config.notifications.iconSize
      source: card.iconSource
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 4

      RowLayout {
        Layout.fillWidth: true
        spacing: Config.notifications.padding

        CardText {
          text: card.notification?.appName ?? ""
          elide: Text.ElideRight
          wrapMode: Text.NoWrap
        }

        CardText {
          readonly property real arrival: NotificationService.arrival(card.notification)

          Layout.fillWidth: false
          visible: arrival > 0
          text: Qt.formatDateTime(new Date(arrival), "HH:mm")
          wrapMode: Text.NoWrap
        }
      }

      CardText {
        visible: text !== ""
        text: card.notification?.summary ?? ""
        color: Config.theme.text
        font { bold: true; pointSize: Config.notifications.titleFontSize }
      }

      CardText {
        visible: text !== ""
        text: card.notification?.body ?? ""
        textFormat: Text.StyledText
        maximumLineCount: 6
        elide: Text.ElideRight
        onLinkActivated: link => Qt.openUrlExternally(link)
      }

      RowLayout {
        visible: card.buttons.length > 0
        Layout.fillWidth: true
        Layout.topMargin: 4
        spacing: Config.notifications.spacing

        Repeater {
          model: card.buttons

          Rectangle {
            id: button

            required property NotificationAction modelData

            Layout.fillWidth: true
            implicitHeight: label.implicitHeight + Config.notifications.padding
            radius: Config.notifications.radius / 2
            color: buttonArea.containsMouse ? Config.theme.focused : Config.theme.inactive

            CardText {
              id: label
              anchors.centerIn: parent
              color: Config.theme.text
              width: parent.width - Config.notifications.padding
              horizontalAlignment: Text.AlignHCenter
              elide: Text.ElideRight
              wrapMode: Text.NoWrap
              text: button.modelData?.text ?? ""
            }

            MouseArea {
              id: buttonArea
              anchors.fill: parent
              hoverEnabled: true
              onClicked: button.modelData.invoke()
            }
          }
        }
      }
    }
  }
}
