import QtQuick
import Quickshell.Networking
import qs.config
import qs.services
import qs.utils

Item {
    id: root
    implicitHeight: background.implicitHeight

    required property WifiNetwork network
    readonly property string ssid: network?.name
    readonly property bool connected: network?.state == ConnectionState.Connected

    property bool expanded: false

    Rectangle {
        id: background
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: Math.max(Style.size.wifiGroupHeight, contentColumn.implicitHeight)

        color: (mouseArea.containsMouse && !root.expanded) ? Style.color.base.surface1 : Style.color.base.surface0
        radius: Style.rounding.small
    }

    Rectangle {
        id: indicator
        visible: root.expanded
        anchors.left: background.left
        anchors.verticalCenter: background.verticalCenter
        anchors.leftMargin: 5

        implicitWidth: 3
        implicitHeight: background.implicitHeight * 2 / 3
        radius: implicitWidth

        color: Style.color.accent.current
    }

    MaterialIcon {
        id: icon
        anchors.left: background.left
        anchors.top: background.top

        text: Icons.getWifiIcon((root.network?.signalStrength ?? 0) * 100)
        color: Style.color.base.text
        size: Style.font.size.large

        height: Style.size.wifiGroupHeight
        width: height
    }

    MouseArea {
        id: mouseArea
        anchors.fill: background
        // enabled: !root.expanded

        hoverEnabled: true
        cursorShape: root.expanded ? Qt.ArrowCursor : Qt.PointingHandCursor

        onClicked: {
            root.expanded = !root.expanded;
        }
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

        Item {
            id: title
            anchors.left: parent.left
            anchors.right: parent.right
            implicitHeight: childrenRect.height

            StyledText {
                id: networkName
                anchors.top: parent.top
                anchors.left: parent.left
                text: root.ssid
            }

            StyledText {
                id: securityType
                anchors.left: parent.left
                anchors.top: networkName.bottom
                color: Style.color.base.subtext
                text: Wifi.securityTypeToString(root.network) +
                        (root.network?.connected ? " | Connected" : (root.network?.known ? " | Saved" : ""))
            }
        }

        WifiGroupContent {
            visible: root.expanded
            anchors.left: parent.left
            anchors.right: parent.right

            network: root.network
            connected: root.connected
            ssid: root.ssid
        }
    }
}
