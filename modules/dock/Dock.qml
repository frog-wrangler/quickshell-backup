import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import qs.config

Scope {
    id: root

    property list<int> screenIds: Quickshell.screens.map((_, i) => i)
    property list<ShellScreen> screens: Quickshell.screens.filter((_, i) => screenIds.includes(i))

    Variants {
        id: variants
        model: root.screens

        PanelWindow {
            id: win
            required property var modelData
            screen: modelData

            WlrLayershell.namespace: "dock"
            exclusionMode: ExclusionMode.Ignore

            anchors.bottom: true

            readonly property var apps: DesktopEntries.applications.values.filter(app => app?.name && app?.icon && Settings.dockedApps.includes(app?.name || ""))

            property int length: apps.length * (Style.spacing.small + Style.size.dockIcon)
            implicitWidth: length
            implicitHeight: Style.size.dockIcon * 1.5 + Style.spacing.small
            color: "transparent"

            mask: Region {
                item: row
            }

            function expand(startIndex) {
                apps.forEach((_, ind) => {
                    repeater.itemAt(ind).delay(Style.size.dockIcon + Style.spacing.small, startIndex);
                });
            }
            function collapse(startIndex) {
                apps.forEach((_, ind) => {
                    repeater.itemAt(ind).delay(0, startIndex);
                });
            }

            Row {
                id: row
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                spacing: 0
                property int current: -1

                Repeater {
                    id: repeater
                    model: win.apps

                    DockItem {
                        parent: row
                        anchors.bottom: parent.bottom
                    }
                }
            }
        }
    }
}
