pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Widgets
import qs.config
import qs.utils
import qs.utils.settings

ContentPage {
    id: root
    baseWidth: Style.size.settingsContentWidth
    forceWidth: true

    property var settings: parent?.settings

    ContentSection {
        title: "Background"
        Layout.topMargin: Style.size.settingsVerticalMargins

        GridView {
            Layout.fillWidth: true
            implicitHeight: 400
            clip: true

            cellHeight: 120
            cellWidth: width / 4

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
            settingId: "clockOnWallpaper"
            active: root.settings.clockOnWallpaper ?? false
        }

        ToggleItem {
            Layout.fillWidth: true
            text: "Clock on Lockscreen"
            settingId: "clockOnLockscreen"
            active: root.settings.clockOnLockscreen ?? false
        }

        ToggleItem {
            Layout.fillWidth: true
            text: "Activate Linux Text"
            settingId: "activateLinux"
            active: root.settings.activateLinux ?? true
        }

        ToggleItem {
            Layout.fillWidth: true
            text: "Wallpaper Under Top Bar"
            settingId: "wallpaperUnderTopBar"
            active: root.settings.wallpaperUnderTopBar ?? false
        }
    }
}
