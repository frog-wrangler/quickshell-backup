import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.config
import qs.utils

ApplicationWindow {
    id: root
    minimumWidth: 600
    minimumHeight: 400
    width: 1100
    height: 750

    color: Style.color.base.mantle
    visible: true

    property int currentPage: 0
    title: "Settings"
    onClosing: Qt.quit()

    property var pages: [
        {
            name: "Style",
            icon: "palette",
            component: "modules/settings/StyleConfig.qml"
        },
        {
            name: "Interface",
            icon: "dashboard_customize",
            component: "modules/settings/InterfaceConfig.qml"
        },
        {
            name: "Misc",
            icon: "settings",
            component: "modules/settings/MiscConfig.qml"
        }
    ]

    menuBar: Item {
        id: topBar
        implicitHeight: 50

        StyledText {
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter

            text: "Settings"
            font.pointSize: Style.font.size.normal
        }

        QuickButton {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 10

            iconName: "close_small"
            backgroundColor: Style.color.base.base
            hoverColor: Style.color.accent.red
            size: parent.implicitHeight - 20
            radius: Style.rounding.small

            onClicked: {
                Qt.quit();
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10

        spacing: 8

        ColumnLayout {
            id: navRail
            Layout.fillHeight: true
            Layout.margins: 5
            Layout.preferredWidth: navTabs.implicitWidth

            property bool expanded: false
            property int currentindex: 0

            QuickButton {
                id: navRailExpandButton
                iconName: "menu"
                hoverColor: Style.color.base.surface0
                size: 40
                radius: Style.rounding.small

                onClicked: navRail.expanded = !navRail.expanded
            }

            Repeater {
                id: navTabs
                model: root.pages
                NavRailButton {
                    required property var index
                    required property var modelData
                    toggled: root.currentPage === index
                    onClicked: root.currentPage = index
                    expanded: navRail.expanded
                    iconName: modelData.icon
                    buttonText: modelData.name
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true

            color: Style.color.base.base
            radius: Style.rounding.large

            Loader {
                id: pageLoader
                anchors.fill: parent
                source: root.pages[root.currentPage].component
            }
        }
    }
}
