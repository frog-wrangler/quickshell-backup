import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.config
import qs.services
import qs.utils

Scope {
    id: root

    HyprlandFocusGrab {
        windows: [panel]
        active: GlobalStates.dashboardOpen
        onCleared: () => {
            if (!active)
                panel.hide();
        }
    }

    PanelWindow {
        id: panel
        anchors.left: true
        anchors.top: true
        anchors.bottom: true
        margins.top: Style.size.barSize + Style.spacing.small
        margins.bottom: Style.spacing.small
        margins.right: Style.spacing.small

        function hide() {
            GlobalStates.dashboardOpen = false;
        }

        color: "transparent"
        visible: GlobalStates.dashboardOpen

        WlrLayershell.namespace: "dashboard"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Top

        implicitWidth: dashContentLoader.implicitWidth

        Loader {
            id: dashContentLoader
            anchors.fill: parent

            active: GlobalStates.dashboardOpen
            focus: GlobalStates.dashboardOpen
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    panel.hide();
                }
            }

            sourceComponent: Rectangle {
                id: background
                anchors.fill: parent

                color: Style.color.base.base
                border.width: 2
                border.color: Style.color.base.surface1

                implicitWidth: Style.size.statusSize
                radius: Style.rounding.normal

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.spacing.extraLarge
                    spacing: Style.spacing.extraLarge
                }
            }
        }
    }
}
