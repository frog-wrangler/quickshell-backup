import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.services

PanelWindow {
    id: root
    // color: "transparent"
    visible: implicitHeight != 0

    anchors.top: true
    margins.top: Style.size.barSize + Style.spacing.small
    implicitWidth: 300
    implicitHeight: 80 * repeater.count

    WlrLayershell.namespace: "notification-list"
    WlrLayershell.layer: WlrLayer.Top
    exclusionMode: ExclusionMode.Ignore

    Column {
        anchors.fill: parent

        Repeater {
            id: repeater
            // model: 
        }
    }
}
