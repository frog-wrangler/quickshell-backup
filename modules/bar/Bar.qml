import QtQuick
import QtQuick.Layouts
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
        anchors.leftMargin: 12
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

    RowLayout {
        id: rightTray
        spacing: 12
        anchors.right: parent.right

        Clock {}
        StatusTray {}
        Power {
            Layout.rightMargin: 12
        }
    }
}
