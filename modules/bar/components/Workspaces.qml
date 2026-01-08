pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.config
import qs.services
import qs.utils

Item {
    id: root
    implicitHeight: Style.size.barSize
    implicitWidth: background.implicitWidth

    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen)
    readonly property list<HyprlandWorkspace> workspaces: Hyprland.workspaces.values.filter(w => w.monitor == root.monitor && w.id >= 0);
    readonly property HyprlandWorkspace secret: Hyprland.workspaces.values.find(w => w.id === -98) ?? null

    required property ShellScreen screen

    Rectangle {
        id: secretWs
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 6
        anchors.leftMargin: root.secret == null ? 0 : undefined
        width: root.secret == null ? 0 : height
        radius: Style.rounding.small
        color: Style.color.base.surface0

        Workspace {
            visible: root.secret != null
            anchors.fill: parent
            index: -98
            modelData: root.secret
        }
    }

    Rectangle {
        id: background
        anchors.left: secretWs.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 6
        implicitWidth: layout.implicitWidth + 10
        radius: height

        color: Style.color.base.surface0
    }

    RowLayout {
        id: layout
        anchors.centerIn: background
        spacing: 5

        Repeater {
            model: root.workspaces
            delegate: Workspace {}
        }
    }

    Component.onCompleted: {
        HyprlandRefresh.start();
    }

    component Workspace: Item {
        id: delegate
        required property HyprlandWorkspace modelData
        required property int index

        readonly property HyprlandWorkspace workspace: modelData
        readonly property bool focused: workspace?.focused ?? false
        readonly property bool occupied: workspace?.toplevels?.values?.length > 0 ?? false

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
            text: delegate.occupied ? Icons.getAppCategoryIcon(delegate.workspace?.toplevels?.values[0]?.lastIpcObject?.class, "computer") : "close_small"
        }

        MouseArea {
            anchors.fill: delegate
            onPressed: {
                if (delegate.index == -98) {
                    Hyprland.dispatch("togglespecialworkspace magic");
                } else if (!delegate.focused) {
                    delegate.workspace.activate();
                }
            }
        }
    }
}
