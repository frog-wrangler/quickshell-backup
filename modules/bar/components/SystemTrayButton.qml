
import QtQuick
import qs.config
import qs.services
import qs.utils
import qs.modules.widgets

Item {
    id: root
    implicitHeight: Style.size.barSize
    implicitWidth: Style.size.barSize

    Rectangle {
        id: background

        readonly property int margin: 6

        color: mouseArea.pressed ? Style.color.base.surface1 : Style.color.base.surface0
        anchors.fill: parent
        anchors.margins: margin
        radius: Style.size.barSize - (2 * margin)

        MaterialIcon {
            anchors.fill: parent

            text: GlobalStates.systemTrayOpen ? "arrow_drop_up" : "arrow_drop_down"
            color: Style.color.base.text
            size: Style.font.size.extraLarge
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            GlobalStates.systemTrayOpen = !GlobalStates.systemTrayOpen;
        }
    }

    SystemTray {}
}
