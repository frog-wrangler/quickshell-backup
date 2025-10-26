import QtQuick
import qs.config
import qs.services
import qs.utils

Item {
    id: root
    implicitHeight: background.implicitHeight

    required property string ssid
    readonly property var group: Network.groupBySsid[ssid]
    readonly property bool connected: Network.active?.ssid == ssid

    property bool expanded: Network.pinnedSsid == ssid

    Rectangle {
        id: background
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: Math.max(Style.size.wifiGroupHeight, contentColumn.implicitHeight)

        color: (mouseArea.containsMouse && !root.expanded) ? Style.color.base.surface1 : Style.color.base.surface0
        radius: Style.rounding.small

        Rectangle {
            id: indicator
            visible: root.expanded
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 5

            implicitWidth: 3
            implicitHeight: parent.implicitHeight * 2 / 3
            radius: implicitWidth

            color: Style.color.accent.current
        }

        MaterialIcon {
            id: icon
            anchors.left: parent.left
            anchors.top: parent.top

            text: Icons.getWifiIcon(root.group?.strength ?? 0) // TODO
            color: Style.color.base.text
            size: Style.font.size.large

            height: Style.size.wifiGroupHeight
            width: height
        }

        Column {
            id: contentColumn
            anchors.left: icon.right
            anchors.right: background.right
            anchors.top: background.top
            anchors.rightMargin: Style.spacing.large

            topPadding: (Style.size.wifiGroupHeight - title.implicitHeight) / 2
            bottomPadding: Style.spacing.large

            spacing: Style.spacing.extraLarge

            Column {
                id: title
                anchors.left: parent.left
                anchors.right: parent.right

                spacing: 3

                StyledText {
                    anchors.left: parent.left
                    text: root.ssid
                }

                StyledText {
                    anchors.left: parent.left

                    text: {
                        if (root.connected) {
                            return "Connected";
                        } else if (Network.autoSsidList.includes(root.ssid)) {
                            return "Saved";
                        }
                        return "";
                    }
                    color: Style.color.base.subtext
                }
            }

            WifiGroupContent {
                anchors.left: parent.left
                anchors.right: parent.right

                ssid: root.ssid
                expanded: root.expanded
                connected: root.connected
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: !root.expanded

            hoverEnabled: true
            cursorShape: root.expanded ? Qt.ArrowCursor : Qt.PointingHandCursor

            onClicked: {
                Network.pin(root.ssid);
            }
        }
    }
}
