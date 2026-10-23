import QtQuick
import Quickshell

import qs.components
import qs.services
import qs.settings

// Bluetooth icon, dimmed and crossed out when off (the same glyph either way,
// so its width doesn't change). Click turns Bluetooth on or off; right-click
// lists paired devices to connect or disconnect. Hidden if there's no adapter.
Text {
  id: root

  visible: BluetoothService.available
  text: Icons.bluetooth
  color: BluetoothService.enabled ? Config.theme.active : Config.theme.inactive
  font {
    family: Config.fontFamily
    pointSize: Config.bar.fontSize
  }

  Slash {
    visible: !BluetoothService.enabled
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: event => {
      if (event.button === Qt.RightButton) menu.openFromBar(root)
      else BluetoothService.toggle()
    }
  }

  Menu {
    id: menu

    // One switch entry per paired device (on = connected), with its battery
    // level when the device reports one.
    model: {
      if (!BluetoothService.enabled) return [{ text: "Bluetooth is off", enabled: false }]
      if (BluetoothService.paired.length === 0) return [{ text: "No paired devices", enabled: false }]
      return BluetoothService.paired.map(device => ({
        text: device.batteryAvailable
          ? `${device.name} · ${Math.round(device.battery <= 1 ? device.battery * 100 : device.battery)}%`
          : device.name,
        buttonType: QsMenuButtonType.CheckBox,
        toggle: true,
        checkState: device.connected ? Qt.Checked : Qt.Unchecked,
        triggered: () => BluetoothService.toggleDevice(device),
      }))
    }
  }
}
