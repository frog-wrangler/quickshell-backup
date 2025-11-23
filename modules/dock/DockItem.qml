import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.config

Rectangle {
    id: item

    property int additionalHeight: 0
    property real pseudoscale: {
        if (row.current == -1) {
            return 0;
        } else {
            const falloff = 2;
            let diff = Math.abs(index - row.current);
            diff = Math.max(0, falloff - diff);
            let damp = falloff - Math.max(1, diff);
            let sc = 0.3;
            if (damp)
                sc /= damp;
            diff = diff / falloff * sc;
            return diff;
        }
    }

    property real length: Style.size.dockIcon * pseudoscale + Style.spacing.large + additionalHeight
    height: length
    width: Style.size.dockIcon + Style.spacing.small

    color: "transparent"

    Timer {
        id: timer
    }

    function delay(height, latestIndex = row.current) {
        timer.interval = Math.abs(index - latestIndex) * Style.anim.durations.tiny;
        timer.repeat = false;
        timer.triggered.connect(() => additionalHeight = height);
        timer.start();
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        propagateComposedEvents: true

        onEntered: {
            row.current = index;
            win.expand();
        }
        onExited: {
            if (row.current == index) {
                row.current = -1; 
                win.collapse(index);
            }
        }
        onClicked: modelData.execute()

        Column {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            topPadding: Style.spacing.large

            width: Style.size.dockIcon
            height: item.height

            Rectangle {
                width: Style.size.dockIcon
                height: width

                color: Style.color.base.surface0
                radius: Style.rounding.small
                border.width: 1
                border.color: Style.color.base.surface1

                Image {
                    anchors.fill: parent
                    anchors.margins: 6

                    source: Quickshell.iconPath(modelData.icon)

                    transform: Scale {
                        origin.x: Style.size.dockIcon / 2
                        origin.y: Style.size.dockIcon / 2
                        xScale: mouseArea.containsPress ? 0.9 : 1
                        yScale: mouseArea.containsPress ? 0.9 : 1
                    }
                }
            }
        }
    }

    Behavior on length {
        NumberAnimation {
            duration: Style.anim.durations.tiny
            easing.type: Easing.OutBack
        }
    }
}
