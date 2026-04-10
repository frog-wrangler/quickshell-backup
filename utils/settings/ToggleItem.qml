import QtQuick
import Quickshell
import qs.config
import qs.utils

Item {
    id: root

    required property string text
    required property string settingId

    property bool active: false

    implicitHeight: Math.max(toggleIcon.implicitHeight, label.implicitHeight) + 10

    StyledText {
        id: label
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        text: root.text
    }

    MaterialIcon {
        id: toggleIcon
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        text: root.active ? "toggle_on" : "toggle_off"
        size: Style.font.size.extraLarge
        color: root.active ? Style.color.accent.current : Style.color.base.subtext
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            Quickshell.execDetached(["qs", "ipc", "call", "settings", "setBool", root.settingId, !active]);
            root.active = !root.active;
        }
    }
}
