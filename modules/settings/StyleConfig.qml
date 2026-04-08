pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Widgets
import qs.config
import qs.services
import qs.utils
import qs.utils.settings

ContentPage {
    id: root
    baseWidth: 550
    forceWidth: true

    ContentSection {
        title: "Background"

        GridView {
            Layout.fillWidth: true
            implicitHeight: 300
            clip: true

            cellHeight: 120
            cellWidth: width / 3

            model: FolderListModel {
                id: folderModel
                folder: "file://" + Quickshell.shellDir + "/data/wallpapers/"
            }

            delegate: WallpaperDelegate {}
        }


    }

    ContentSection {
        title: "Decorations & Effects"

        ToggleItem {
            Layout.fillWidth: true
            text: "Clock on Wallpaper"
            active: Settings.map.clockOnWallpaper

            onClicked: {
                Quickshell.execDetached(["qs", "ipc", "call", "background", "setClockOnWallpaper", !active]);
            }
        }

        ToggleItem {
            Layout.fillWidth: true
            text: "Clock on Lockscreen"
            active: Settings.map.clockOnLockscreen

            onClicked: {
                Quickshell.execDetached(["qs", "ipc", "call", "background", "setClockOnLockscreen", !active]);
            }
        }
    }

    ContentSection {
        title: "Fake Screen Rounding"
    }
}
