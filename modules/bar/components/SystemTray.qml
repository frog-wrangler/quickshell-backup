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

Row {
    id: row
    anchors.verticalCenter: parent.verticalCenter
    clip: true

    property bool expanded: true

    MaterialIcon {
        anchors.verticalCenter: parent.verticalCenter
        text: row.expanded || SystemTray.items.values.length == 0 ? "chevron_right" : "chevron_left"
        color: Style.color.base.subtext
        size: Style.font.size.large

        height: Style.size.barSize - Style.spacing.normal
        width: 15

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                row.expanded = !row.expanded;
            }
        }
    }

    Repeater {
        model: SystemTray.items
        delegate: Item {
            id: iconRoot
            visible: row.expanded
            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: Style.size.systemTrayItem
            implicitHeight: implicitWidth

            required property var modelData

            Rectangle {
                id: bg
                anchors.fill: parent
                radius: Style.rounding.small
                color: mouseArea.containsMouse ? Style.color.base.surface0 : "transparent"
            }

            Image {
                id: icon
                anchors.centerIn: bg

                readonly property int margins: Style.spacing.extraSmall
                width: iconRoot.implicitWidth - 2 * margins
                height: iconRoot.implicitHeight - 2 * margins
                source: iconRoot.modelData.icon
            }

            MouseArea {
                id: termArea
                anchors.fill: parent
                acceptedButtons: Qt.MiddleButton

                Process {
                    id: sendTerm
                    command: ["sh", "-c", ["for pid in $(pidof ", iconRoot.modelData.tooltipTitle.toLowerCase().trim() || iconRoot.modelData.id, "); do kill -9 $pid; done"].join("")]
                }

                onClicked: {
                    if (iconRoot.modelData.id) {
                        sendTerm.running = true;
                    } else {
                        console.error("did not sent terminate action due to no id");
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onClicked: {
                    iconRoot.modelData.secondaryActivate();
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent

                acceptedButtons: Qt.LeftButton
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                onClicked: {
                    if (iconRoot.modelData.id == "steam") {
                        Quickshell.execDetached(["steam"]);
                    } else {
                        iconRoot.modelData.activate();
                    }
                }
            }
        }
    }

    add: Transition {
        NumberAnimation {
            properties: "scale"; 
            from: 0.5
            to: 1
            duration: Style.anim.durations.small
            easing.type: Easing.OutCubic 
        }
    }
}
