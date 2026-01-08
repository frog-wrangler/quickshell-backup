pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property bool idleOn: true
    property int idleTime: 240
    property bool idleActive: false
}
