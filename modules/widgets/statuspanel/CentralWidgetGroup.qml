import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.utils
import qs.config
import qs.modules.widgets.statuspanel.tabs

Rectangle {
    id: root
    color: "transparent"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TabBar {
            id: tabBar
            Layout.fillWidth: true
            Layout.preferredHeight: Style.size.statusPanelTabBarHeight

            currentIndex: swipeView.currentIndex

            TabTitle {
                title: "Notifications"
                iconName: "notifications_active"
                active: tabBar.currentIndex === 0
            }
            
            TabTitle {
                title: "Wifi"
                iconName: "network_manage"
                active: tabBar.currentIndex === 1
            }

            TabTitle {
                title: "Bluetooth"
                iconName: "settings_bluetooth"
                active: tabBar.currentIndex === 2
            }

            background: Rectangle {
                border.width: 0
                color: "transparent"
            }

            Component.onCompleted: {
                tabBar.setCurrentIndex(0);
            }
        }

        Rectangle {
            id: separator
            Layout.fillWidth: true
            Layout.margins: 5
            implicitHeight: 1

            color: Style.color.base.surface1
        }


        SwipeView {
            id: swipeView
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: Style.spacing.normal
            currentIndex: tabBar.currentIndex

            clip: true

            NotificationTab {}
            WifiTab {}
            BluetoothTab {}
        }
    }
}
