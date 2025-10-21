import QtQuick
import QtQuick.Controls
import Quickshell.Bluetooth
import qs.utils.bluetooth
import qs.utils
import qs.services
import qs.config

Item {
    id: root

    readonly property bool isActive: SwipeView.isCurrentItem
    readonly property var bAdapter: Bluetooth.defaultAdapter

    ListView {
        id: bluetoothList
        anchors.fill: parent

        spacing: 6

        model: root.bAdapter.devices
        delegate: BluetoothItem {
            anchors.left: parent?.left
            anchors.right: parent?.right

            required property var modelData
            device: modelData
        }

        footerPositioning: ListView.OverlayFooter
        footer: Item {
            anchors.right: parent.right
            anchors.left: parent.left
            implicitHeight: 40

            z: 3

            Rectangle {
                id: footerBackground
                anchors.fill: parent
                color: Style.color.base.mantle
                radius: Style.rounding.normal
            }

            StyledText {
                anchors.left: parent.left
                anchors.verticalCenter: scanToggle.verticalCenter
                anchors.leftMargin: 12

                text: `${root.bAdapter.devices.values.length} devices`
            }

            ToggleButton {
                id: scanToggle
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 5
                
                active: root.bAdapter?.discovering ?? false
                function swap(): void {
                    if (root.bAdapter?.enabled) root.bAdapter.discovering = !root.bAdapter.discovering;
                }
                
                inactiveColor: root.bAdapter?.enabled ? Style.color.base.surface0 : Style.color.base.crust
                activeColor: Style.color.accent.current
                iconInactiveColor: Style.color.base.text
                iconActiveColor: Style.color.base.base
                
                iconNameInactive: root.bAdapter?.enabled ? "bluetooth_searching" : "bluetooth_disabled"
                iconNameActive: "bluetooth_searching"
            }
        }
    }
    
    Component.onDestruction: {
        if (bAdapter.enabled) bAdapter.discovering = false;
    }
}
