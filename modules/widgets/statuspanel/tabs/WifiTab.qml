import QtQuick
import QtQuick.Controls
import qs.utils.wifi
import qs.utils
import qs.services
import qs.config

Item {
    id: root

    readonly property bool isActive: SwipeView.isCurrentItem

    ListView {
        id: wifiList
        anchors.fill: parent

        spacing: Style.spacing.extraSmall

        model: Network.ssidList
        delegate: WifiGroup {
            anchors.left: parent?.left
            anchors.right: parent?.right

            required property var modelData
            ssid: modelData
        }

        footerPositioning: ListView.OverlayFooter
        footer: Item {
            id: wifiFooter
            anchors.right: parent.right
            anchors.left: parent.left
            implicitHeight: Style.size.statusPanelTabFooter

            z: 3

            Rectangle {
                id: footerBackground
                anchors.fill: parent

                color: Style.color.base.mantle
                radius: Style.rounding.normal
            }

            QuickButton {
                anchors.left: parent.left
                anchors.leftMargin: Style.spacing.normal / 2
                anchors.verticalCenter: parent.verticalCenter
                height: Style.size.statusPanelTabFooter - Style.spacing.normal
                width: height

                iconName: "refresh"
                backgroundColor: "transparent"
                hoverColor: Style.color.base.surface0
                size: Style.font.size.normal
                radius: Style.rounding.small / 2

                onClicked: {
                    Network.refresh();
                }
            }

            StyledText {
                anchors.centerIn: parent
                text: `${Network.networks.length} access points | ${Network.ssidList.length} networks`
            }
        }

        Component.onDestruction: {
            Network.pin("");
        }
    }

    onIsActiveChanged: {
        Network.pin("");
    }

    Timer {
        running: root.isActive && Network.pinnedSsid == ""
        repeat: true
        interval: Style.choice.wifiListRefreshInterval

        onTriggered: {
            Network.refresh();
        }
    }
}
