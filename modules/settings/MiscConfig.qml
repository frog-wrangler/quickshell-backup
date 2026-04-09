import qs.utils.settings

ContentPage {
    id: root
    baseWidth: 550
    forceWidth: true

    property var settings: parent?.settings

    ContentSection {
        title: "Audio"
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
