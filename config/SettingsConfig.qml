pragma Singleton

import QtQuick
import Quickshell

Singleton {
    // temp settings
    property bool idleOn: true

    // to be migrated to settings system
    readonly property bool notificationPopups: true
    readonly property int idleTime: 120
    readonly property bool showBluetoothInTray: false
    readonly property bool lockedOnBoot: false
    readonly property bool hideNoSsid: true
    readonly property bool topBarShowDate: true
    readonly property bool wallpaperUnderTopBar: true

    readonly property int wifiListRefreshInterval: 10000
    readonly property int wifiIconRefreshInterval: 2000
    readonly property int systemUsageRefreshInterval: 2000

    readonly property string unlockStartMessage: "Unlock Attempt Started"
    readonly property string fingerprintFailure: "Fingerprint Failed"
    readonly property string noNotificationText: "No Notifications"
}
