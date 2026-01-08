import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.services
import qs.utils

PanelWindow {
    id: root
    anchors.bottom: true
    color: "transparent"

    WlrLayershell.namespace: "power-panel"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top

    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    Rectangle {
        id: background
        anchors.fill: parent
        anchors.bottomMargin: Style.spacing.large * 2

        implicitWidth: layout.implicitWidth + 25
        implicitHeight: layout.implicitHeight + 55
        radius: Style.rounding.large

        color: Style.color.base.base
        border.width: 2
        border.color: Style.color.base.surface1

        focus: GlobalStates.powerPanelOpen
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                GlobalStates.powerPanelOpen = false;
            }
        }

        RowLayout {
            id: layout
            anchors.centerIn: parent

            spacing: Style.spacing.normal
            uniformCellSizes: true

            SessionButton {
                id: lock

                icon: "logout"
                command: ["qs", "ipc", "call", "lock", "activate"]
            }

            SessionButton {
                id: sleep

                icon: "bedtime"
                command: ["systemctl", "sleep"]
            }

            SessionButton {
                id: reboot

                icon: "cached"
                command: ["systemctl", "reboot"]
            }

            SessionButton {
                id: shutdown

                icon: "power_settings_new"
                command: ["systemctl", "poweroff"]
            }
        }
    }
}
