import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.services

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: backWin

        property var modelData
        screen: modelData
        WlrLayershell.namespace: "background"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Background

        color: Style.color.base.base

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Wallpaper {
            id: wallpaper
            screen: backWin.screen
        }

        Loader {
            active: Settings.map.clockOnWallpaper
            sourceComponent: DesktopClock {
                id: clock
                parent: wallpaper

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
