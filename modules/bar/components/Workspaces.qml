pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.config
import qs.services
import qs.utils

Item {
    id: root
    implicitHeight: Style.size.barSize
    implicitWidth: background.implicitWidth

    readonly property list<HyprlandWorkspace> workspaces: Hyprland.workspaces.values.filter(w => w.id >= 0)
    readonly property HyprlandWorkspace secret: Hyprland.workspaces.values.find(w => w.id === -98) ?? null

    Rectangle {
        id: background
        anchors.fill: parent
        anchors.margins: 6
        implicitWidth: layout.implicitWidth + 16
        radius: height

        color: Style.color.base.surface0
    }

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 5

        Repeater {
            model: root.workspaces

            Item {
                id: delegate
                required property var modelData
                readonly property int wsNum: modelData.id
                readonly property bool focused: modelData.focused
                readonly property bool occupied: true

                Layout.preferredWidth: childrenRect.width
                Layout.preferredHeight: childrenRect.height

                Rectangle {
                    visible: delegate.focused
                    anchors.centerIn: parent
                    width: 24
                    height: 24
                    radius: 12
                    color: Style.color.accent.current
                }

                MaterialIcon {
                    anchors.centerIn: parent
                    size: Style.font.size.normal
                    color: delegate.focused ? Style.color.base.crust : Style.color.base.subtext
                    text: Icons.getAppCategoryIcon(delegate.modelData.toplevels?.values[0]?.lastIpcObject?.class, "close_small");
                }
            }
        }
    }

    MouseArea {
        anchors.fill: background

        onPressed: event => {
            const ws = layout.childAt(event.x, event.y)?.wsNum ?? -1;
            if (ws === -1)
                return;
            if ((Hyprland.focusedWorkspace?.id ?? ws) !== ws)
                Hyprland.dispatch(`workspace ${ws}`);
        }
    }

    Component.onCompleted: {
        HyprlandRefresh.start();
    }
}
