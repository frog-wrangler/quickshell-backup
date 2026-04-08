pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

Singleton {
    id: root

    property string wallpaperPath: ""

    property color clockColor: Style.color.base.text
    property double clockOpacity: 0.6
    property string clockPosition: "bottomLeft"
    property string lockscreenClockPosition: "bottomLeft"
    property int clockMargins: 100

    Process {
        id: randomWallpaper
        running: true
        command: ["sh", "-c", "find ~/.config/quickshell/data/wallpapers/ -type f | shuf -n 1"]
        stdout: SplitParser {
            onRead: path => {
                root.wallpaperPath = path;
            }
        }
    }
}
