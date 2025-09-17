pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import qs.config

Singleton {
    id: root
     
    property bool powerPanelOpen: false
    property bool statusPanelOpen: false
    property bool dropdownOpen: false

    property bool screenLocked: LockConfig.lockedOnBoot

    property bool wifiActive: false
    property bool bluetoothActive: false
    property bool batterySaverOn: false

    Component.onCompleted: {
        checkWifiState.running = true;
        checkBluetoothState.running = true;
        checkPowerSaver.running = true;
    }

    Process {
        id: checkPowerSaver
        command: ["powerprofilesctl", "get"]
        stdout: SplitParser {
            onRead: data => {
                if (data.includes("save")) root.batterySaverOn = true;
            }
        }
    }

    Process {
        id: checkWifiState
        command: ["sh", "-c", "nmcli radio wifi | grep enabled"]
        stdout: SplitParser {
            onRead: data => {
                root.wifiActive = (data.length > 0);
            }
        }
    }

    Process {
        id: checkBluetoothState
        command: ["sh", "-c", "bluetoothctl show | grep -q 'Powered: yes' && echo 1 || echo 0"]
        stdout: SplitParser {
            onRead: data => {
                root.bluetoothActive = (parseInt(data) === 1);
            }
        }
    }
}
