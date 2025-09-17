import QtQuick
import QtQuick.Layouts
import "root:/config"
import "root:/services"
import "root:/utils"

Item {
    id: root

    required property int index
    readonly property int wsNum: index + 1
    required property var occupied

    readonly property bool isWorkspace: true
    readonly property bool isOccupied: occupied[wsNum] ?? false
    readonly property bool isActive: Hyprland.activeWsId === wsNum

    Layout.preferredWidth: childrenRect.width
    Layout.preferredHeight: childrenRect.height

    Rectangle {
        id: active
        visible: isActive
        anchors.centerIn: parent
        width: 24
        height: 24
        radius: 12
        color: Style.color.accent.current
    }

    MaterialIcon {
        id: icon
        anchors.centerIn: parent

        size: Style.font.size.normal
        color: isActive ? Style.color.base.crust : Style.color.base.subtext
        text: {
            if (root.isOccupied) {
                return Icons.getAppCategoryIcon(Hyprland.workspaces.values[wsNum]?.toplevels?.values[0]?.lastIpcObject?.class, "computer")
            } else {
                return "close_small"
            }
        }
    }
}
