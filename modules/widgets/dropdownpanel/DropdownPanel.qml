import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.services
import qs.config

Scope {
    HyprlandFocusGrab {
        id: grab
        windows: [ panel ]
        active: GlobalStates.dropdownOpen
        onCleared: () => {
            if (!active) panel.hide();
        }
    }

    PanelWindow {
        id: panel
        anchors.top: true
        implicitWidth: 760
        implicitHeight: 500

        WlrLayershell.namespace: "dropdown-panel"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Top

        function hide() {
            GlobalStates.dropdownOpen = false;
        }

        color: "transparent"
        visible: GlobalStates.dropdownOpen

        Loader {
            id: loader
            anchors.fill: parent
            active: GlobalStates.dropdownOpen
            focus: GlobalStates.dropdownOpen
            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_Escape) {
                    panel.hide();
                }
            }
               
            sourceComponent: Rectangle {
                id: background
                anchors.fill: parent
                
                color: Style.color.base.base
                border.width: 2
                border.color: Style.color.base.surface1
                radius: 30
                topLeftRadius: 0
                topRightRadius: 0

                Rectangle {
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        leftMargin: 2
                        rightMargin: 2
                    }
                    height: 2
                    color: parent.color
                }

                DropdownContent {
                    anchors.fill: parent
                    anchors.margins: 20
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.NoButton
                    onExited: closeDelay.start()
                    onEntered: closeDelay.stop()
                }

                Timer {
                    id: closeDelay
                    interval: 150
                    repeat: false
                    onTriggered: panel.hide()
                }
            }
        }
    }
}
