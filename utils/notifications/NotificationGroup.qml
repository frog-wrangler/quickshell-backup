import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.config
import qs.utils

Item {
    id: root
    implicitHeight: background.implicitHeight

    required property var notificationGroup

    property var notifications: notificationGroup?.notifications ?? []
    property int notificationCount: notifications.length
    property bool expanded: false
    property real padding: 10

    function toggleExpanded() {
        expanded = !expanded;
    }

    function remove() {
        root.notifications.forEach((notif) => {
            Qt.callLater(() => {
                NotificationHandler.discardNotification(notif.notificationId);
            });
        });
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onClicked: (click) => {
            if (click.button === Qt.MiddleButton) {
                root.remove();
            } else {
                root.toggleExpanded();
            }
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: Style.color.base.surface0
        radius: Style.rounding.normal
        clip: false

        implicitHeight: Math.max(80, row.implicitHeight + root.padding * 2)

        RowLayout {
            id: row
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: root.padding
            }

            spacing: 10

            NotificationAppIcon {
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 2
                appIcon: root.notificationGroup?.appIcon ?? ""
            }

            // Content
            ColumnLayout {
                id: column
                Layout.fillWidth: true
                spacing: (root.expanded && notificationGroup?.notifications[root.notificationCount - 1].image != "") ? 40 : 10

                // App name
                Item {
                    id: topRow
                    Layout.fillWidth: true
                    implicitHeight: Math.max(topTextRow.implicitHeight, expandButton.implicitHeight)

                    RowLayout {
                        id: topTextRow
                        anchors.left: parent.left
                        anchors.right: expandButton.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 5
                        
                        StyledText {
                            id: appName
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            text: notificationGroup?.appName ?? ""
                            font.pointSize: Style.font.size.small
                            color: Style.color.accent.current
                        }
                        
                        StyledText {
                            id: timestamp
                            Layout.rightMargin: 10
                            horizontalAlignment: Text.AlignLeft
                            text: getTime()
                            font.pointSize: Style.font.size.small
                            color: Style.color.base.subtext

                            function getTime() {
                                return new Date(notificationGroup?.time ?? 0).toLocaleTimeString("en-US");
                            }
                        }
                    }

                    NotificationExpandButton {
                        id: expandButton
                        anchors.right: parent.right

                        open: root.expanded
                        numNotifications: root.notificationCount
                    }
                }

                // Expanded notifications
                ListView {
                    id: notificationColumn
                    implicitHeight: childrenRect.height
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 5
                    interactive: false

                    model: ScriptModel {
                        values: root.expanded ? root.notifications.slice().reverse() : 
                            root.notifications.slice().reverse().slice(0, 2)
                    } 
                    delegate: NotificationItem {
                        required property int index
                        required property var modelData

                        notificationObject: modelData
                        expanded: root.expanded
                        onlyNotification: (root.notificationCount === 1)
                        opacity: (!root.expanded && index == 1 && root.notificationCount > 2) ? 0.5 : 1
                        visible: root.expanded || (index < 2)
                        anchors.left: parent?.left
                        anchors.right: parent?.right
                    }
                }
            }
        }
    }
}
