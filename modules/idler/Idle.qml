import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.services

Scope {
    id: root

    property real prevBrightness: 0
    property bool goingToIdle: false

    IdleMonitor {
        id: shortMonitor
        enabled: SettingsConfig.idleOn
        timeout: SettingsConfig.idleTime //seconds

        onIsIdleChanged: {
            if (!isIdle) {
                Brightness.setBrightness(root.prevBrightness);
            } else {
                Brightness.update();
                root.goingToIdle = true;
            }
        }
    }

    Connections {
        target: Brightness
        function onChanged(brightness) {
            if (brightness <= 0) return;
            root.prevBrightness = brightness;

            if (root.goingToIdle) {
                Brightness.setBrightness(0);
                root.goingToIdle = false;
            }
        }
    }
}
