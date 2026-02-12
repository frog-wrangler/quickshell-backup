import QtQuick
import QtQuick.Controls
import qs.utils.wifi
import qs.utils
import qs.services
import qs.config

ListView {
    id: wifiList

    spacing: Style.spacing.extraSmall

    model: Wifi.networks
    delegate: WifiGroup {
        anchors.left: parent?.left
        anchors.right: parent?.right

        required property var modelData
        network: modelData
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

        StyledText {
            anchors.centerIn: parent
            text: `${Wifi.networks?.values.length} networks | ${Wifi.nmstateString} | ${Wifi.devModeString}`
        }
    }
}
