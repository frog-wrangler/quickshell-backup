pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

Singleton {
    id: root

    property string wallpaperPath: "root:/data/wallpapers/ching_yeh1.jpg"

    property color clockColor: Style.color.base.text
    property string clockPosition: "bottomLeft"
    property string lockscreenClockPosition: "bottomLeft"
    property int clockMargins: 100
    property bool showClockOnWallpaper: false
    property bool showClockOnLockscreen: false

    IpcHandler {
        target: "background"

        function setWallpaper(url: string): void {
            root.wallpaperPath = url;
            Settings.set("wallpaper", url);
        }

        function setClockOnWallpaper(val: bool): void {
            root.showClockOnWallpaper = val;
            Settings.set("clockOnWallpaper", val);
        }

        function setClockOnLockscreen(val: bool): void {
            root.showClockOnLockscreen = val;
            Settings.set("clockOnLockscreen", val);
        }
    }

    Connections {
        target: Settings
        function onLoaded() {
            root.wallpaperPath = Settings.getValue("wallpaper");
            root.showClockOnWallpaper = Settings.getValue("clockOnWallpaper");
            root.showClockOnLockscreen = Settings.getValue("clockOnLockscreen");
        }
    }
}
