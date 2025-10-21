import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import qs.services
import qs.modules.widgets.dropdownpanel.tabs

Item {
    id: root

    Tabs {
        id: tabs
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        currentIndex: view.currentIndex
    }

    ClippingRectangle {
        anchors.top: tabs.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        color: "transparent"
        radius: 15

        SwipeView {
            id: view
            anchors.fill: parent

            currentIndex: tabs.currentIndex
            spacing: 10

            Dashboard {}
            Media {}
            Performance {}
        }
    }
}
