pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.config
import qs.utils

Item {
    id: root
    implicitHeight: expanded ?
            (appInfo.implicitHeight + notifList.implicitHeight + Style.spacing.extraLarge + notifList.anchors.topMargin)
            : 90

    required property var notificationGroup

    property var notifications: notificationGroup.notifications
    property int notificationCount: notifications.count
    property bool expanded: false

    function toggleExpanded() {
        expanded = !expanded;
    }

    onNotificationCountChanged: {
        if (notificationCount <= 2) {
            secondSummary.text = (notifications.get(1)?.summary ?? "");
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: Style.color.base.surface0
        radius: Style.rounding.normal
        clip: true
    }

    // App Information
    Item {
        id: appInfo
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Style.spacing.normal
        implicitHeight: appIconDisplay.visible ? appIconDisplay.height : expandButton.height

        NotificationAppIcon {
            id: appIconDisplay
            visible: appIcon != ""
            anchors.top: parent.top
            anchors.left: parent.left

            size: 90 - 2 * Style.spacing.normal
            appIcon: root.notificationGroup.appIcon ||
                    (Settings.map.notificationIconPlaceholder ? (Quickshell.shellDir + "/data/graphics/sillyguy.png") : "")
        }

        StyledText {
            id: appName
            anchors.left: appIconDisplay.visible ? appIconDisplay.right : parent.left
            anchors.leftMargin: appIconDisplay.visible ? Style.spacing.normal : undefined

            elide: Text.ElideRight
            text: root.notificationGroup.appName
            font.pointSize: Style.font.size.small
            color: Style.color.accent.current
        }

        // Summaries when unexpanded
        StyledText {
            id: firstSummary
            visible: !root.expanded
            anchors.left: appName.left
            anchors.top: appName.bottom
            anchors.topMargin: Style.spacing.normal - 3

            elide: Text.ElideRight
            text: root.notifications.get(0)?.summary
            font.pointSize: Style.font.size.small
            color: Style.color.base.text
        }

        StyledText {
            id: secondSummary
            visible: !root.expanded && text != ""
            anchors.left: appName.left
            anchors.top: firstSummary.bottom
            anchors.topMargin: Style.spacing.small

            elide: Text.ElideRight
            text: root.notifications.get(1)?.summary ?? ""
            font.pointSize: Style.font.size.small
            color: Style.color.base.text
            opacity: 0.6
        }

        Rectangle {
            id: expandButton
            anchors.right: parent.right

            height: 20
            width: 30 + notifNum.implicitWidth
            radius: Style.rounding.large

            color: Style.color.base.surface1

            StyledText {
                id: notifNum
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 8
                text: root.notificationCount
            }

            MaterialIcon {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 3

                text: root.expanded ? "arrow_drop_up" : "arrow_drop_down"
                size: Style.font.size.large
                color: Style.color.base.text
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onClicked: root.toggleExpanded();
    }

    // Notification List
    ListView {
        id: notifList
        visible: root.expanded

        anchors.top: appInfo.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Style.spacing.normal
        anchors.topMargin: root.notifications.get(0).image == "" ? -35 : undefined
        implicitHeight: childrenRect.height

        spacing: 5
        interactive: false

        model: root.notifications

        delegate: NotificationItem {
            anchors.left: parent?.left
            anchors.right: parent?.right

            required property var modelData
            notificationObject: modelData
        }
    }
}
