pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string wallpaperPath: "root:/data/wallpapers/ching_yeh1.jpg"

    IpcHandler {
        target: "wallpaper"
        function set(url: string): void {
            root.wallpaperPath = url;
        }
    }

    readonly property string lockscreenWallpaperPath: "root:/data/wallpapers/pink_skull.jpg"

    readonly property color clockColor: Style.color.base.text
    readonly property string clockPosition: "bottomRight"
    readonly property string lockscreenClockPosition: "topLeft"
    readonly property int clockMargins: 100
    readonly property bool showClockOnWallpaper: false
    readonly property bool showClockOnLockscreen: true
}
