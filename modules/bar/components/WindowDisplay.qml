import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.config
import qs.services
import qs.utils

Item {
    id: root
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Style.size.barSize

    property string activeWindow: Hyprland.activeToplevel?.title ?? "Desktop"

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: Style.spacing.normal

        MaterialIcon {
            size: Style.font.size.large
            color: Style.color.base.text
            text: Icons.getAppCategoryIcon(Hyprland.activeToplevel?.lastIpcObject?.class, "computer")
        }

        StyledText {
            Layout.maximumWidth: 300

            font.pointSize: Style.font.size.normal
            text: root.activeWindow
            elide: Text.ElideRight
        }
    }
}
