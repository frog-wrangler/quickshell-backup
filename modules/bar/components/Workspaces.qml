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

    readonly property list<HyprlandWorkspace> workspaces: Hyprland.workspaces.values.filter(w => w.id >= 0);
    readonly property HyprlandWorkspace secret: Hyprland.workspaces.values.find(w => w.id === -98) ?? null
    readonly property int maxWsIndex: Math.max(...workspaces.map(w => w.id))

    required property ShellScreen screen

    Rectangle {
        id: secretWs
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 6
        width: height
        radius: Style.rounding.small
        color: Style.color.base.surface0

        Workspace {
            anchors.centerIn: parent
            index: -98
            workspace: root.secret
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
            model: Math.max(root.maxWsIndex, 6)
            delegate: Workspace {}
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

    component Workspace: Item {
        id: delegate
        required property int index

        property var workspace: root.workspaces.find(w => w.id === index + 1)

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
    }
}
