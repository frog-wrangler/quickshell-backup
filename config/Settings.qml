pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property list<string> dockedApps: ["kitty", "Firefox"]
}
