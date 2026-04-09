pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: root

    property alias map: adapter

    FileView {
        id: jsonFile
        path: Quickshell.shellDir + "/data/settings.json"
        blockLoading: true

        onAdapterUpdated: writeAdapter()
        JsonAdapter {
            id: adapter

            property color clockColor: Style.color.base.text
            property double clockOpacity: 0.6
            property string clockPosition: "bottomLeft"
            property string lockscreenClockPosition: "bottomLeft"
            property int clockMargins: 100

            property string wallpaper: "root:/data/wallpapers/astronaut_jellyfish.jpg"
            property bool clockOnWallpaper: true
            property bool clockOnLockscreen: true
            property bool wallpaperUnderTopBar: true

            property bool activateLinux: true

            property bool notificationPopups: true
            property bool notificationIconPlaceholder: true

            property bool idleOn: true
            property int idleTime: 120
            property int idleLockTime: 900

            property bool lockedOnBoot: false

            property bool showBluetoothInTray: false
            property bool topBarShowDate: true

            property int systemUsageRefreshInterval: 2000
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
