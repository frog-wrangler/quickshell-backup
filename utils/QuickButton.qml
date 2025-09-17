import QtQuick
import QtQuick.Controls
import "root:/config"

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

        implicitWidth: size ? size : buttonIcon.implicitWidth + 40
        implicitHeight: implicitWidth
        radius: root.radius ? root.radius : 3

        MouseArea {
            id: mouseArea
            anchors.centerIn: parent
            height: size ? size : buttonIcon.implicitWidth + 40
            width: height
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
        }
    }
}
