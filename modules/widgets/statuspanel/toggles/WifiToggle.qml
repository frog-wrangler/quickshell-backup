import Quickshell.Io
import qs.services
import qs.config
import qs.utils

ToggleButton {
    id: root
    active: GlobalStates.wifiActive
    function swap(): void {
        GlobalStates.wifiActive = !GlobalStates.wifiActive;
    }

    inactiveColor: "transparent"
    activeColor: Style.color.accent.current
    iconInactiveColor: Style.color.base.text
    iconActiveColor: Style.color.base.surface0

    iconNameInactive: "signal_wifi_off"
    iconNameActive: "signal_wifi_4_bar"
}
