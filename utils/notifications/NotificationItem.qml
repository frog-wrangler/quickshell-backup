import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import qs.utils
import qs.config
import qs.services

Item {
    id: root
    height: content.childrenRect.height + 2 * Style.spacing.small

    required property var notificationObject
    property var urgency: notificationObject?.urgency

    readonly property int iconSizeDiff: (90 - 2 * Style.spacing.normal - Style.size.notificationAppIcon) / 2
    
    NotificationAppIcon {
        id: appIcon
        visible: image != ""
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: root.iconSizeDiff
        image: root.notificationObject.image
    }

    Rectangle {
        id: background
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: appIcon.right
        anchors.leftMargin: Style.spacing.normal + root.iconSizeDiff

        radius: Style.rounding.small

        color: (root.urgency == NotificationUrgency.Critical) ?
                Style.color.accent.red :
                Style.color.base.surface1
    }

    Item {
        id: content
        anchors.fill: background

        property color textColor: (root.urgency == NotificationUrgency.Critical) ? Style.color.base.surface0 : Style.color.base.text

        StyledText {
            id: summary
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: xIcon.left
            anchors.margins: Style.spacing.small

            text: root.notificationObject.summary
            color: content.textColor
            elide: Text.ElideRight
            font.bold: true
        }

        MaterialIcon {
            id: xIcon
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 2
            height: 30
            width: height

            text: "close"
            size: Style.font.size.large
            color: content.textColor

            MouseArea {
                anchors.centerIn: parent
                height: parent.height
                width: height

                cursorShape: Qt.ForbiddenCursor
                onClicked: {
                    root.eradicate();
                }
            }
        }

        StyledText {
            visible: root.notificationObject.body !== ""
            anchors.top: summary.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: Style.spacing.small

            text: root.notificationObject.body
            color: content.textColor
            elide: Text.ElideRight
            wrapMode: Text.Wrap
        }
    }

    function eradicate() {
        NotificationHandler.discardNotification(notificationObject.notificationId);
    }
}
