import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import qs.config
import qs.utils
import qs.services

Item {
    id: root
    implicitHeight: background.implicitHeight

    required property var device

    Rectangle {
        id: background
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: Math.max(40, textColumn.implicitHeight + 20)

        color: (mouseArea.containsMouse && !mouseArea.pressed) ? Style.color.base.surface1 : Style.color.base.surface0
        radius: Style.rounding.small
    }

    MaterialIcon {
        id: bluetoothIcon
        anchors.top: background.top
        anchors.left: background.left
        height: 40
        width: height

        text: Icons.getBluetoothIcon(root.device?.icon)
        size: Style.font.size.normal
        color: Style.color.base.text
    }

    ColumnLayout {
        id: textColumn
        anchors.left: bluetoothIcon.right
        anchors.right: background.right
        anchors.verticalCenter: background.verticalCenter

        StyledText {
            // Layout.alignment: Qt.AlignLeft
            text: root.device?.name ?? "Unknown Device"
        }

        StyledText {
            visible: text != ""
            color: Style.color.base.subtext
            text: {
                if (root.device == null) return "";

                switch (root.device.state) {
                    case BluetoothDeviceState.Connected:
                        return "Connected";
                    case BluetoothDeviceState.Connecting:
                        return "Connecting...";
                    case BluetoothDeviceState.Disconnecting:
                        return "Disconnecting...";
                    default:
                        break;
                }

                if (root.device.bonded) return "Bonded";
                if (root.device.paired) return "Paired";
                if (root.device.pairing) return "Pairing";

                return "";
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: background

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (root.device == null || root.device.connected) return;

            if (root.device.connected) root.device.disconnect();

            if (!root.device.paired) {
                root.device.pair();
            } else {
                root.device.connect();
            }
        }
    }
}
