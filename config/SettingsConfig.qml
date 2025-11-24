pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property list<string> dockedApps: ["kitty", "Firefox", "Vesktop"]
    readonly property bool idleBrightness: true
    readonly property int idleTime: 240
}
