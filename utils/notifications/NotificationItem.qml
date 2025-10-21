import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import qs.utils
import qs.config
import qs.services

Item {
    id: root
    Layout.fillWidth: true
    implicitHeight: background.implicitHeight

    required property var notificationObject
    required property bool expanded
    required property bool onlyNotification
    
    property var urgency: notificationObject?.urgency
    readonly property int padding: expanded ? 8 : 0

    Rectangle {
        id: background
        anchors.left: parent.left
        width: parent.width
        implicitHeight: root.expanded ? (contentColumn.implicitHeight + root.padding * 2) : summary.implicitHeight

        radius: Style.rounding.small

        color: {
            if (!root.expanded) {
                return "transparent";
            }

            if (root.urgency == NotificationUrgency.Critical) {
                return Style.color.accent.red;
            } else {
                return Style.color.base.surface1;
            }
        }

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: root.padding
            spacing: 3

            property color textColor: (root.urgency == NotificationUrgency.Critical && root.expanded) ? Style.color.base.surface0 : Style.color.base.text
            
            RowLayout {
                id: summaryRow
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop

                StyledText {
                    id: summary
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop

                    text: notificationObject.summary
                    color: contentColumn.textColor
                    elide: Text.ElideRight
                    font.bold: true
                }

                MaterialIcon {
                    Layout.rightMargin: 8
                    height: parent.height
                    width: height

                    text: "close"
                    size: Style.font.size.large
                    color: contentColumn.textColor

                    MouseArea {
                        height: summaryRow.height
                        width: height
                        anchors.centerIn: parent
                        cursorShape: Qt.ForbiddenCursor

                        onClicked: {
                            root.eradicate();
                        }
                    }
                }
            }

            StyledText {
                visible: root.expanded && root.notificationObject.body !== ""

                Layout.fillHeight: true
                Layout.fillWidth: true
                text: root.notificationObject.body
                color: contentColumn.textColor
                elide: Text.ElideRight
                wrapMode: Text.Wrap
            }
        }
    }

    NotificationAppIcon {
        id: appIcon
        visible: (root.expanded && root.notificationObject.image !== "")
        anchors.right: background.left
        anchors.top: background.top
        anchors.rightMargin: 10
        image: root.notificationObject.image
    }

    function eradicate() {
        NotificationHandler.discardNotification(notificationObject.notificationId);
    }
}
