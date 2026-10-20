import Quickshell
import Quickshell.Wayland
import QtQuick

// Full-screen wallpaper on the background layer of one monitor.
PanelWindow {
  required property var modelData
  screen: modelData

  anchors { top: true; bottom: true; left: true; right: true }
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Background
  WlrLayershell.namespace: "quickshell:wallpaper"
  color: Config.theme.bg

  Image {
    anchors.fill: parent
    source: Config.wallpaper ? "file://" + Config.wallpaper : ""
    fillMode: Image.PreserveAspectCrop
    asynchronous: true
    onStatusChanged: if (status === Image.Error) console.warn("Wallpaper failed to load:", Config.wallpaper)
    // Decode at screen resolution rather than the image's full size.
    sourceSize {
      width: parent.width * modelData.devicePixelRatio
      height: parent.height * modelData.devicePixelRatio
    }
  }
}
