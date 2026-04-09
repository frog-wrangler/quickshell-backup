import qs.utils.settings

ContentPage {
    id: root
    baseWidth: 550
    forceWidth: true

    property var settings: parent?.settings

    ContentSection {
        title: "Top Bar"
    }

    ContentSection {
        title: "Status Panel"
    }

    ContentSection {
        title: "Dropdown Panel"
    }

    ContentSection {
        title: "Power Panel"
    }
}
