import QtQuick
import Quickshell.Services.UPower
import Quickshell.Bluetooth
import "root:/config"
import "root:/services"
import "root:/modules/widgets/statuspanel"
import "root:/utils"

Item {
    id: root
    implicitHeight: Style.size.barSize
    implicitWidth: background.implicitWidth

    Rectangle {
        id: background

        readonly property int verticalMargin: 6

        color: Style.color.base.surface0
        anchors.fill: parent
        anchors.topMargin: verticalMargin
        anchors.bottomMargin: verticalMargin
        radius: Style.size.barSize - (2 * verticalMargin)
        implicitWidth: icons.implicitWidth + 10

        Row {
            id: icons
            anchors.fill: parent
            anchors.margins: 5
            spacing: 4

            MaterialIcon {
                id: batteryIcon
                anchors.verticalCenter: parent.verticalCenter
                color: !UPower.onBattery || UPower.displayDevice.percentage > 0.25
                        ? (UPower.displayDevice.percentage > 0.5 ? Style.color.base.text : Style.color.accent.orange)
                        : Style.color.accent.red
                size: Style.font.size.normal

                text: {
                    const percent = UPower.displayDevice.percentage;
                    const charging = !UPower.onBattery;

                    if (percent === 1)
                        return charging ? "battery_charging_full" : "battery_full";
                    let level = Math.floor(percent * 7);
                    if (charging && (level === 4 || level === 1))
                        level--;
                    return charging ? `battery_charging_${(level + 3) * 10}` : `battery_${level}_bar`;
                }
            }

            MaterialIcon {
                id: wifi
                anchors.verticalCenter: parent.verticalCenter
                color: Style.color.base.text
                size: Style.font.size.normal

                text: SimpleNetwork.iconName
            }

            MaterialIcon {
                id: bluetooth
                anchors.verticalCenter: parent.verticalCenter
                color: Style.color.base.text
                size: Style.font.size.normal

                text: Bluetooth.defaultAdapter?.enabled ? "bluetooth" : "bluetooth_disabled"
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: {
            GlobalStates.statusPanelOpen = !GlobalStates.statusPanelOpen;
        }
    }

    StatusPanel {}
}
