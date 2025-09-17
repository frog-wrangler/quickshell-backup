import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "root:/utils/wifi"
import "root:/utils"
import "root:/services"
import "root:/config"

Item {
    id: root

    readonly property bool isActive: SwipeView.isCurrentItem

    ListView {
        id: wifiList
        anchors.fill: parent

        spacing: 6

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
            implicitHeight: 40

            z: 3

            Rectangle {
                id: footerBackground
                anchors.fill: parent

                color: Style.color.base.mantle
                radius: Style.rounding.normal
                bottomLeftRadius: 0
                bottomRightRadius: 0
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
        interval: 10000

        onTriggered: {
            Network.refresh();
        }
    }
}
