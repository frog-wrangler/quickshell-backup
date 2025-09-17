import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/config"

Rectangle {
    id: root

    required property string icon
    required property list<string> command
    property color iconColor: hovered ? Style.color.base.base : Style.color.base.text
    property bool hovered: area.containsMouse

    Layout.preferredHeight: 60
    Layout.preferredWidth: 60

    radius: Style.rounding.normal
    color: hovered ? Style.color.accent.current : Style.color.base.surface0

    MouseArea {
        id: area
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: {
            Quickshell.execDetached(parent.command);
        }
    }

    MaterialIcon {
        anchors.centerIn: parent

        text: parent.icon
        color: parent.iconColor
        size: (parent.width * 0.4) || 1
    }
}
