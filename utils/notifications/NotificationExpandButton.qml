import QtQuick
import qs.config
import qs.utils

Rectangle {
    id: root
    height: 20
    width: number.width + icon.width + Style.spacing.small
    color: Style.color.base.surface1
    radius: 15

    required property bool open
    required property int numNotifications
    
    StyledText {
        id: number
        anchors.right: icon.left
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: Style.font.size.small / 1.2
        text: root.numNotifications
    }

    MaterialIcon {
        id: icon
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: 20

        text: root.open ? "arrow_drop_down" : "arrow_drop_up"
        color: Style.color.base.text
        size: Style.font.size.extraLarge
    }
}
