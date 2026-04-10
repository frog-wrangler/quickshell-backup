import QtQuick.Layouts
import qs.config
import qs.utils.settings

ContentPage {
    id: root
    baseWidth: Style.size.settingsContentWidth
    forceWidth: true

    property var settings: parent?.settings

    ContentSection {
        title: "Top Bar"
        Layout.topMargin: Style.size.settingsVerticalMargins

        ToggleItem {
            Layout.fillWidth: true
            text: "Show Bluetooth in Tray"
            settingId: "showBluetoothInTray"
            active: root.settings.showBluetoothInTray ?? false
        }

        ToggleItem {
            Layout.fillWidth: true
            text: "Show Date in Top Bar"
            settingId: "topBarShowDate"
            active: root.settings.topBarShowDate ?? false
        }
    }

    ContentSection {
        title: "Status Panel"

        ToggleItem {
            Layout.fillWidth: true
            text: "Notification Icon Placeholder"
            settingId: "notificationIconPlaceholder"
            active: root.settings.notificationIconPlaceholder ?? true
        }
    }

    ContentSection {
        title: "Dashboard"
    }

    ContentSection {
        title: "Power Panel"
    }
}
