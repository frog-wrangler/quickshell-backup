import QtQuick
import QtQuick.Controls
import qs.utils
import qs.config
import qs.services

Item {
    id: root
    implicitHeight: tabBar.implicitHeight + 20
    implicitWidth: parent.implicitWidth

    property alias currentIndex: tabBar.currentIndex

    TabBar {
        id: tabBar
        anchors.fill: parent

        TabTitle {
            title: "Dashboard"
            iconName: "dashboard"
            active: tabBar.currentIndex === 0
        }
        
        TabTitle {
            title: "Media"
            iconName: "library_music"
            active: tabBar.currentIndex === 1
        }

        TabTitle {
            title: "Performance"
            iconName: "bar_chart"
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

    Item {
        id: indicator
        anchors.bottom: tabBar.bottom
        anchors.bottomMargin: 10

        implicitWidth: parent.width / (tabBar.count * 3)
        implicitHeight: 4
        
        x: {
            const tab = tabBar.currentItem;
            const width = root.width / tabBar.count;
            return (width * tab.TabBar.index) + ((width - implicitWidth) / 2);
        }

        clip: true

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            implicitHeight: parent.implicitHeight * 2

            radius: parent.implicitHeight
            color: Style.color.accent.current
        }
    }

    Rectangle {
        id: separator
        anchors.top: indicator.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: 1

        color: Style.color.base.surface1
    }
}
