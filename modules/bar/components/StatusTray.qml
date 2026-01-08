import QtQuick
import Quickshell.Services.UPower
import Quickshell.Bluetooth
import qs.config
import qs.services
import qs.modules.widgets.statuspanel
import qs.utils

Item {
    id: root
    implicitHeight: Style.size.barSize
    implicitWidth: background.implicitWidth + 2 * Style.size.topBarMargin

    Rectangle {
        id: background

        anchors.fill: parent
        anchors.margins: Style.size.topBarMargin

        implicitWidth: icons.implicitWidth + 16

        radius: Style.size.barSize
        color: mouseArea.pressed ? Style.color.base.surface1 : Style.color.base.surface0

        Row {
            id: icons
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Style.spacing.small
            spacing: Style.spacing.small

            MaterialIcon {
                id: notifications
                visible: NotificationHandler.list.length > 0
                anchors.verticalCenter: parent.verticalCenter
                color: Style.color.base.text
                size: Style.font.size.normal

                text: "notifications_unread"
            }

            MaterialIcon {
                id: batteryIcon
                anchors.verticalCenter: parent.verticalCenter
                color: !UPower.onBattery || UPower.displayDevice.percentage > 0.25 ? (UPower.displayDevice.percentage > 0.5 ? Style.color.base.text : Style.color.accent.orange) : Style.color.accent.red
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
                visible: Style.choice.showBluetoothInTray
                anchors.verticalCenter: parent.verticalCenter
                color: Style.color.base.text
                size: Style.font.size.normal

                text: Bluetooth.defaultAdapter?.enabled ? "bluetooth" : "bluetooth_disabled"
            }

            MaterialIcon {
                id: powerIcon
                anchors.verticalCenter: parent.verticalCenter
                color: Style.color.base.text
                size: Style.font.size.normal

                text: "power_settings_new"
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            GlobalStates.statusPanelOpen = !GlobalStates.statusPanelOpen;
        }
    }
}
