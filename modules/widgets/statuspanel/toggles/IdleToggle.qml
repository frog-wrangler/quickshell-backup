import Quickshell.Io
import qs.services
import qs.config
import qs.utils

ToggleButton {
    id: root
    active: !Settings.map.idleOn
    function swap(): void {
        Settings.map.idleOn = !Settings.map.idleOn;
    }

    inactiveColor: "transparent"
    activeColor: Style.color.accent.current
    iconInactiveColor: Style.color.base.text
    iconActiveColor: Style.color.base.surface0

    iconNameInactive: "coffee"
    iconNameActive: "coffee"
}
