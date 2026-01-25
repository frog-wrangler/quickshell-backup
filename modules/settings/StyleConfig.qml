pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
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

            model: FolderListModel {
                id: folderModel
                folder: "file://" + Quickshell.shellDir + "/data/wallpapers/"
            }

            delegate: WallpaperDelegate {}
        }

        ToggleItem {
            Layout.fillWidth: true
            text: "Clock on Wallpaper"
            active: Settings.getValue("clockOnWallpaper")

            onClicked: {
                Quickshell.execDetached(["qs", "ipc", "call", "background", "setClockOnWallpaper", !active]);
            }
        }

        ToggleItem {
            Layout.fillWidth: true
            text: "Clock on Lockscreen"
            active: Settings.getValue("clockOnLockscreen")

            onClicked: {
                Quickshell.execDetached(["qs", "ipc", "call", "background", "setClockOnLockscreen", !active]);
            }
        }
    }

    ContentSection {
        title: "Decorations & Effects"

        ToggleItem {
            Layout.fillWidth: true
            text: "Testing"

            onClicked: {
                console.log("Clicked!");
            }
        }
    }

    ContentSection {
        title: "Fake Screen Rounding"
    }
}
