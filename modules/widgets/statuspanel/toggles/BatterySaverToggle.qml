import QtQuick
import Quickshell.Services.UPower
import qs.services
import qs.config
import qs.utils

ToggleButton {
    id: root
    active: GlobalStates.batterySaverOn
    function swap(): void {
        GlobalStates.batterySaverOn = !GlobalStates.batterySaverOn;
    }

    inactiveColor: "transparent"
    activeColor: Style.color.accent.current
    iconInactiveColor: Style.color.base.text
    iconActiveColor: Style.color.base.surface0

    iconNameInactive: "bolt"
    iconNameActive: "battery_saver"

    onClicked: {
        if (PowerProfiles.profile == PowerProfile.PowerSaver) { 
            PowerProfiles.profile = PowerProfile.Balanced;
        } else {
            PowerProfiles.profile = PowerProfile.PowerSaver;
        }
    }
}
