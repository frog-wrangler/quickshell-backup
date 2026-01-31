import QtQuick
import Quickshell
import qs.utils.notifications
import qs.utils
import qs.services
import qs.config

ListView {
    id: root

    spacing: Style.spacing.extraSmall
    clip: true

    model: ScriptModel {
        values: NotificationHandler.appNameList ?? []
    }

    delegate: NotificationGroup {
        required property int index
        required property var modelData

        anchors.left: parent?.left
        anchors.right: parent?.right

        notificationGroup: NotificationHandler.groupsByAppName[modelData]
    }

    headerPositioning: ListView.OverlayHeader
    header: Rectangle {
        visible: root.model.values.length == 0
        anchors.left: parent?.left
        anchors.right: parent?.right
        implicitHeight: visible ? Style.size.noNotificationHeight : 0

        color: Style.color.base.surface0
        radius: Style.rounding.small

        StyledText {
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter

            text: SettingsConfig.noNotificationText
            color: Style.color.base.subtext
            font.pointSize: Style.font.size.normal
        }
    }

    footerPositioning: ListView.OverlayFooter
    footer: Item {
        anchors.left: parent?.left
        anchors.right: parent?.right
        implicitHeight: Math.max(notifCount.height, button.height)

        z: 3

        StyledText {
            id: notifCount
            anchors.verticalCenter: parent?.verticalCenter
            text: NotificationHandler.list.length + " notifications"
            font.pointSize: Style.font.size.normal
        }

        QuickButton {
            id: button
            anchors.right: parent?.right
            iconName: "delete"
            backgroundColor: Style.color.base.surface0
            hoverColor: Style.color.base.surface1
            onClicked: {
                NotificationHandler.discardAllNotifications();
            }
        }
    }
}
