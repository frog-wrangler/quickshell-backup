import QtQuick
import QtQuick.Controls
import qs.config
import qs.services

Button {
    id: root
    required property bool active

    required property color inactiveColor
    required property color activeColor
    required property color iconInactiveColor
    required property color iconActiveColor

    required property string iconNameInactive
    required property string iconNameActive

    contentItem: MaterialIcon {
        id: buttonIcon
        text: root.active ? root.iconNameActive : root.iconNameInactive
        color: active ? root.iconActiveColor : root.iconInactiveColor
        size: Style.font.size.large

        width: 40
    }

    background: Rectangle {
        id: background
        color: root.active ? root.activeColor : root.inactiveColor

        implicitWidth: buttonIcon.implicitWidth + 60
        implicitHeight: buttonIcon.implicitWidth + 30
        radius: implicitHeight / 2.4

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
        }
    }

    function toggleActive(): void {
        root.swap();
    }

    onClicked: {
        root.toggleActive();
    }
}
