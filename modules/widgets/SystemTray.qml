pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.SystemTray
import qs.config
import qs.services
import qs.utils

Scope {
    id: root

    HyprlandFocusGrab {
        windows: [tray]
        active: GlobalStates.systemTrayOpen
        onCleared: () => {
            if (!active)
                GlobalStates.systemTrayOpen = false;
        }
    }

    PanelWindow {
        id: tray

        anchors.right: true
        anchors.top: true
        margins.right: Math.max(Style.spacing.small, 98 - systemContentLoader.implicitWidth / 2)
        margins.top: Style.size.barSize + Style.spacing.small

        function hide() {
            GlobalStates.systemTrayOpen = false;
        }

        color: "transparent"
        visible: GlobalStates.systemTrayOpen

        WlrLayershell.namespace: "system-tray"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Top

        implicitWidth: systemContentLoader.implicitWidth
        implicitHeight: systemContentLoader.implicitHeight

        Loader {
            id: systemContentLoader
            anchors.fill: parent

            active: GlobalStates.systemTrayOpen
            focus: GlobalStates.systemTrayOpen
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    tray.hide();
                }
            }

            sourceComponent: Rectangle {
                id: background
                anchors.fill: parent

                color: Style.color.base.base
                border.width: 2
                border.color: Style.color.base.surface1

                readonly property int margins: Style.spacing.small

                implicitWidth: row.implicitWidth + 2 * margins
                implicitHeight: row.implicitHeight + 2 * margins
                radius: Style.rounding.normal

                Row {
                    id: row
                    anchors.centerIn: parent

                    Rectangle {
                        width: 130
                        height: 75
                        color: "transparent"
                        visible: SystemTray.items.values.length == 0

                        StyledText {
                            anchors.centerIn: parent
                            width: parent.width - 10

                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                            text: "No background processes"
                        }
                    }

                    Component.onCompleted: {
                        for (const item of SystemTray.items.values) {
                            iconComp.createObject(row, {
                                data: item
                            });
                        }
                    }
                }
            }
        }
    }

    Component {
        id: iconComp

        Item {
            id: iconRoot
            implicitWidth: Style.size.systemTrayItem
            implicitHeight: implicitWidth

            required property var data

            children: [
                Rectangle {
                    id: bg
                    anchors.fill: parent
                    radius: Style.rounding.small
                    color: mouseArea.containsMouse ? Style.color.base.surface0 : "transparent"
                },
                Image {
                    id: icon
                    anchors.centerIn: bg

                    readonly property int margins: Style.spacing.extraSmall
                    width: iconRoot.implicitWidth - 2 * margins
                    height: iconRoot.implicitHeight - 2 * margins
                    source: iconRoot.data.icon
                },
                MouseArea {
                    id: termArea
                    anchors.fill: parent
                    acceptedButtons: Qt.MiddleButton

                    Process {
                        id: sendTerm
                        command: ["sh", "-c", ["for pid in $(pidof ", iconRoot.data.tooltipTitle.toLowerCase().trim() || iconRoot.data.id, "); do kill -9 $pid; done"].join("")]
                        stdout: StdioCollector {
                            onStreamFinished: {
                                tray.hide();
                            }
                        }
                    }

                    onClicked: {
                        if (iconRoot.data.id) {
                            sendTerm.running = true;
                        } else {
                            console.error("did not sent terminate action due to no id");
                        }
                    }
                },
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onClicked: {
                        iconRoot.data.secondaryActivate();
                    }
                },
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent

                    acceptedButtons: Qt.LeftButton
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: {
                        if (iconRoot.data.id == "steam") {
                            Quickshell.execDetached(["steam"]);
                        } else {
                            iconRoot.data.activate();
                        }

                        tray.hide();
                    }
                }
            ]
        }
    }
}
