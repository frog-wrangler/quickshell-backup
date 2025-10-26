import QtQuick
import Quickshell
import qs.config
import qs.modules.bar.components
import qs.modules.bar.components.workspaces

PanelWindow {
    id: topPanel
    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Style.size.barSize

    // Visual bar
    Rectangle {
        id: topBar
        color: Style.color.base.base
        anchors.fill: parent
    }

    // Components
    OsIcon {
        id: osIcon
        anchors.left: parent.left
        anchors.leftMargin: Style.spacing.normal
    }

    Workspaces {
        id: leftTray
        anchors.left: osIcon.left
        anchors.leftMargin: 20
    }

    SongWindowDisplay {
        id: centerTray
        anchors.centerIn: parent
    }

    DropdownArea {
        id: dropdownArea
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Clock {
        id: clockDisplay
        anchors.right: systemTray.left
    }

    SystemTrayButton {
        id: systemTray
        anchors.right: statusTray.left
    }

    StatusTray {
        id: statusTray
        anchors.right: parent.right
    }
}
