import QtQuick
import Quickshell
import "root:/utils/notifications"
import "root:/utils"
import "root:/services"
import "root:/config"

ListView {
    id: root

    spacing: 3
    clip: true

    model: ScriptModel {
        values: NotificationHandler.appNameList
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
        visible: NotificationHandler.appNameList.length == 0
        anchors.left: parent?.left
        anchors.right: parent?.right
        implicitHeight: visible ? 80 : 0
        
        color: Style.color.base.surface0
        radius: Style.rounding.small

        StyledText {
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter

            text: "No new notifications"
            color: Style.color.base.subtext
            font.pointSize: Style.font.size.large
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

