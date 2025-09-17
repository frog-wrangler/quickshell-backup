import QtQuick
import Quickshell.Io
import Quickshell.Bluetooth
import "root:/services"
import "root:/config"
import "root:/utils"

ToggleButton {
    id: root
    active: GlobalStates.bluetoothActive
    function swap(): void {
        GlobalStates.bluetoothActive = !GlobalStates.bluetoothActive;
    }

    inactiveColor: "transparent"
    activeColor: Style.color.accent.current
    iconInactiveColor: Style.color.base.text
    iconActiveColor: Style.color.base.surface0

    iconNameInactive: "bluetooth_disabled"
    iconNameActive: "bluetooth"

    onClicked: {
        if (Bluetooth.defaultAdapter != null) {
            Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
        }
    }
}
