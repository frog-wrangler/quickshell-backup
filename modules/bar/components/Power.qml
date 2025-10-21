import QtQuick
import Quickshell.Hyprland
import qs.config
import qs.services
import qs.utils
import qs.modules.widgets

Item {
    id: root
    implicitHeight: Style.size.barSize
    implicitWidth: powerIcon.width

    Rectangle {
        id: background
        visible: mouseArea.containsMouse
        anchors.centerIn: parent
        height: Style.size.barSize - 10
        width: Style.size.barSize - 10
        radius: 8
        color: Style.color.base.surface1
    }
    
    MaterialIcon {
        id: powerIcon
        color: Style.color.accent.current
        text: "power_settings_new"
        size: Style.font.size.large
    }

    MouseArea {
        id: mouseArea
        anchors.fill: background
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            GlobalStates.powerPanelOpen = !GlobalStates.powerPanelOpen;
        }
    }

    PowerPanel {
        id: menu
        visible: GlobalStates.powerPanelOpen
    }

    HyprlandFocusGrab {
        id: grab
        windows: [ menu ]
        active: GlobalStates.powerPanelOpen
        onCleared: () => {
            if (!active) GlobalStates.powerPanelOpen = false;
        }
    }
}
