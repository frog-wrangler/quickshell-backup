import QtQuick
import qs.config

Item {
    id: root
    property bool active: false
    signal clicked()

    implicitHeight: Math.max(toggleIcon.implicitHeight, label.implicitHeight) + 10

    StyledText {
        id: label
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        text: "Testing"
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
            root.clicked();
            root.active = !root.active;
        }
    }
}
