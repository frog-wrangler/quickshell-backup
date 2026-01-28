pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: root

    property int updateInterval: SettingsConfig.wifiIconRefreshInterval
    property string networkName: ""
    property int networkStrength
    property string iconName: (networkName.length > 0 && networkName != "lo") ? Icons.getWifiIcon(networkStrength) : "signal_wifi_off"

    function update() {
        updateNetworkName.running = true;
        updateNetworkStrength.running = true;
    }

    Timer {
        interval: 10
        running: true
        repeat: true
        onTriggered: {
            root.update();
            interval = root.updateInterval;
        }
    }

    Process {
        id: updateNetworkName
        command: ["sh", "-c", "nmcli -t -f NAME c show --active | head -1"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                root.networkName = data;
            }
        }
    }

    Process {
        id: updateNetworkStrength
        command: ["sh", "-c", "nmcli -f IN-USE,SIGNAL device wifi | awk '/^\*/{if (NR!=1) {print $2}}'"]
        stdout: SplitParser {
            onRead: data => {
                root.networkStrength = parseInt(data);
            }
        }
    }
}
