import QtQuick
import qs.config
import qs.services
import qs.utils
import qs.modules.widgets.dashboard

Item {
    id: root
    implicitHeight: Style.size.barSize
    implicitWidth: Style.size.barSize

    property int size: 28

    Rectangle {
        id: background
        anchors.centerIn: parent
        implicitHeight: root.size
        implicitWidth: root.size

        color: {
            if (mouseArea.containsPress) {
                return Style.color.base.surface1;
            } else if (mouseArea.containsMouse) {
                return Style.color.base.surface0;
            }
            return Style.color.base.base;
        }
        radius: Style.rounding.small
    }

    StyledText {
        id: osIcon
        anchors.centerIn: parent

        color: Style.color.accent.current
        font.family: Style.font.family.mono
        font.pointSize: Style.font.size.large
        text: "󰣇"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: {
            GlobalStates.dashboardOpen = !GlobalStates.dashboardOpen;
        }
    }

    Dashboard {}
}
