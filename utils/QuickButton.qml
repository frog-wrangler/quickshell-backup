import QtQuick
import QtQuick.Controls
import qs.config

Button {
    id: root

    required property string iconName
    property color backgroundColor: "transparent"
    property color hoverColor: "transparent"
    property int size
    property int radius

    contentItem: MaterialIcon {
        id: buttonIcon
        text: iconName
        color: Style.color.base.text
        size: Style.font.size.extraLarge

        width: 40
    }

    background: Rectangle {
        id: background
        color: mouseArea.containsMouse ? root.hoverColor : root.backgroundColor

        implicitWidth: root.size ? root.size : buttonIcon.implicitWidth + 40
        implicitHeight: implicitWidth
        radius: root.radius ? root.radius : 3

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
        }
    }
}
