import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.UPower
import qs.config
import qs.services
import qs.utils
import qs.modules.widgets
import qs.modules.widgets.statuspanel.toggles

Scope {
    id: root

    HyprlandFocusGrab {
        windows: [ menu ]
        active: GlobalStates.powerPanelOpen
        onCleared: () => {
            if (!active) GlobalStates.powerPanelOpen = false;
        }
    }

    PowerPanel {
        id: menu
        visible: GlobalStates.powerPanelOpen
    }

    HyprlandFocusGrab {
        windows: [ panel ]
        active: GlobalStates.statusPanelOpen
        onCleared: () => {
            if (!active) panel.hide();
        }
    }

    PanelWindow {
        id: panel
        anchors.right: true
        anchors.top: true
        anchors.bottom: true
        margins.top: Style.size.barSize + Style.spacing.small
        margins.bottom: Style.spacing.small
        margins.right: Style.spacing.small

        function hide() {
            GlobalStates.statusPanelOpen = false;
        }

        color: "transparent"
        visible: GlobalStates.statusPanelOpen

        WlrLayershell.namespace: "status-panel"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Top

        implicitWidth: statusContentLoader.implicitWidth
        
        Loader {
            id: statusContentLoader
            anchors.fill: parent

            active: GlobalStates.statusPanelOpen
            focus: GlobalStates.statusPanelOpen
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

                implicitWidth: Style.size.statusSize
                radius: Style.rounding.normal

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.spacing.extraLarge
                    spacing: Style.spacing.extraLarge

                    RowLayout {
                        Layout.fillHeight: false
                        spacing: Style.spacing.extraLarge / 2
                        Layout.margins: Style.spacing.extraLarge / 2
                        Layout.topMargin: Style.spacing.small
                        Layout.bottomMargin: 0

                        StyledText {
                            text: (UPower.onBattery ? "Discharging: " : "Recharging: ") + Math.round(UPower.displayDevice.percentage * 100) + "%"
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        ButtonGroup {
                            QuickButton {
                                id: restartButton
                                iconName: "restart_alt"
                                hoverColor: Style.color.base.surface1
                                onClicked: {
                                    Quickshell.reload(true);
                                }
                            }

                            QuickButton {
                                id: settingsButton
                                iconName: "settings"
                                hoverColor: Style.color.base.surface1
                                onClicked: {
                                    GlobalStates.statusPanelOpen = false;
                                    Quickshell.execDetached(["qs", "-p", Quickshell.shellPath("settings.qml")]);
                                }
                            }

                            QuickButton {
                                id: powerButton
                                iconName: "power_settings_new"
                                hoverColor: Style.color.base.surface1
                                onClicked: {
                                    GlobalStates.statusPanelOpen = false;
                                    GlobalStates.powerPanelOpen = !GlobalStates.powerPanelOpen;
                                }
                            }

                        }
                    }

                    ButtonGroup {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.bottomMargin: 30
                        spacing: 5
                        padding: 5

                        WifiToggle {}
                        BluetoothToggle {}
                        BatterySaverToggle {}
                    }

                    CentralWidgetGroup {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
