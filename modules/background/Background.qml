import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: backWin

        property var modelData
        screen: modelData
        WlrLayershell.namespace: "background"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Background

        color: Style.color.base.base

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Wallpaper { screen: backWin.screen }

        Loader {
            active: DesktopBackground.showClockOnWallpaper
            DesktopClock {
                id: clock
                property string pos: DesktopBackground.clockPosition

                anchors {
                    top: pos == "topLeft" || pos == "topRight" ? parent.top : undefined
                    bottom: pos == "bottomLeft" || pos == "bottomRight" ? parent.bottom : undefined
                    left: pos == "topLeft" || pos == "bottomLeft" ? parent.left : undefined
                    right: pos == "topRight" || pos == "bottomRight" ? parent.right : undefined
                }
            }
        }
    }
}
