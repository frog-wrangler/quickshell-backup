pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias map: adapter

    FileView {
        id: jsonFile
        path: ".config/quickshell/data/settings.json"
        blockLoading: true

        onAdapterUpdated: writeAdapter()
        JsonAdapter {
            id: adapter

            property string wallpaper: "root:/data/wallpapers/astronaut_jellyfish.jpg"
            property bool clockOnWallpaper: true
            property bool clockOnLockscreen: true
            readonly property bool wallpaperUnderTopBar: true

            readonly property bool notificationPopups: true
            readonly property bool notificationIconPlaceholder: true

            property bool idleOn: true
            readonly property int idleTime: 120
            readonly property int idleLockTime: 900

            readonly property bool lockedOnBoot: false

            readonly property bool showBluetoothInTray: false
            readonly property bool topBarShowDate: true

            readonly property int systemUsageRefreshInterval: 2000
        }

        onLoadFailed: error => {
            console.error(error);
        }

        onSaveFailed: error => {
            console.error(error);
        }
    }

    IpcHandler {
        target: "settings"

        /// Returns a stringified map of the current settings
        function getMap(): string {
            return JSON.stringify(adapter, null, 4);
        }

        function setString(id: string, value: string): void { adapter[id] = value; }
        function setInt(id: string, value: int): void       { adapter[id] = value; }
        function setBool(id: string, value: bool): void     { adapter[id] = value; }
        function setReal(id: string, value: real): void     { adapter[id] = value; }
        function setColor(id: string, value: color): void   { adapter[id] = value; }
    }
}
