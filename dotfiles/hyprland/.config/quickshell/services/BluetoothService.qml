pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Bluetooth

// Bluetooth via BlueZ (needs bluetooth.service running). This only turns the
// default adapter on and off and connects paired devices; pair new devices
// with bluetoothctl.
Singleton {
  id: root

  readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
  readonly property bool available: adapter !== null
  readonly property bool enabled: adapter?.enabled ?? false
  // Paired devices on the default adapter, by name.
  readonly property var paired: Array.from(adapter?.devices.values ?? [])
    .filter(device => device.paired)
    .sort((a, b) => a.name.localeCompare(b.name))

  function toggle() {
    if (adapter) adapter.enabled = !adapter.enabled
  }

  function toggleDevice(device: var) {
    if (device.connected) device.disconnect()
    else device.connect()
  }
}
