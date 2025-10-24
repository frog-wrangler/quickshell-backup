pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property string wallpaperPath: {
        const images = [
            "root:/data/wallpapers/fish.png",
            "root:/data/wallpapers/cute_kitten.png",
            "root:/data/wallpapers/astronaut_jellyfish.jpg",
            "root:/data/wallpapers/deer_pillars.jpg",
            "root:/data/wallpapers/firewatch_green.jpg",
            "root:/data/wallpapers/neon_moon_ocean.jpg",
            "root:/data/wallpapers/totoro.jpg",
        ];

        return images[0];
    }

    readonly property string lockscreenWallpaperPath: "root:/data/wallpapers/deer_pillars.jpg"

    readonly property color clockColor: Style.color.base.text
    readonly property string clockPosition: "bottomRight"
    readonly property string lockscreenClockPosition: "topLeft"
    readonly property int clockMargins: 100
    readonly property bool showClockOnWallpaper: false
    readonly property bool showClockOnLockscreen: true
}
