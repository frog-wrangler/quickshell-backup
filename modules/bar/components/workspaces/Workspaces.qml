import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services

Item {
    id: root
    implicitHeight: Style.size.barSize
    implicitWidth: background.implicitWidth

    readonly property list<Workspace> workspaces: layout.children.filter(c => c.isWorkspace).sort((w1, w2) => w1.wsNum - w2.wsNum)
    readonly property var occupied: Hyprland.workspaces.values.reduce((acc, curr) => {
        acc[curr.id] = curr.lastIpcObject.windows > 0;
        return acc;
    }, {})

    Rectangle {
        id: background
        anchors.fill: parent
        anchors.margins: 6
        implicitWidth: layout.implicitWidth + 16
        radius: (Style.size.barSize - (2 * 6)) / 2

        color: Style.color.base.surface0
    }

    RowLayout {
        id: layout
        anchors.centerIn: parent

        spacing: 5
        layer.enabled: true
        layer.smooth: true

        Repeater {
            model: 10

            Workspace {
                occupied: root.occupied
            }
        }
    }

    MouseArea {
        anchors.fill: background
        cursorShape: Qt.PointingHandCursor

        onPressed: event => {
            const ws = layout.childAt(event.x, event.y)?.wsNum ?? -1;
            if (ws === -1)
                return;
            if (Hyprland.activeWsId !== ws)
                Hyprland.dispatch(`workspace ${ws}`);
        }
    }
}
