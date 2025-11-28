pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property list<string> dockedApps: ["kitty", "Firefox", "Vesktop", "IntelliJ IDEA Community EAP"]
    property bool idleOn: true
    property int idleTime: 240
}
