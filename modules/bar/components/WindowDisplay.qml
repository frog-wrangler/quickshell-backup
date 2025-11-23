import QtQuick
import QtQuick.Layouts
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
            font.pointSize: Style.font.size.normal
            text: root.activeWindow.length > 25 ? root.activeWindow.slice(0, 25).trim() + "..." : root.activeWindow
            // TODO: make elide not whatever this is
        }
    }
}
