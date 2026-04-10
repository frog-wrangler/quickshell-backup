import QtQuick.Layouts
import qs.config
import qs.utils.settings

ContentPage {
    id: root
    baseWidth: Style.size.settingsContentWidth
    forceWidth: true

    property var settings: parent?.settings

    ContentSection {
        title: "Audio"
        Layout.topMargin: Style.size.settingsVerticalMargins
    }

    ContentSection {
        title: "Notifications"
    }

    ContentSection {
        title: "Battery"
    }

    ContentSection {
        title: "Time"
    }

    ContentSection {
        title: "Polling Interval"
    }
}
