pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: root

    property bool inUse: false

    property int lastCpuIdle
    property int lastCpuTotal
    property real cpuPercent
    property real cpuTemp

    property real gpuPercent
    property real gpuTemp

    property int memUsed
    property int memTotal
    property real memPercent 

    property int diskId
    property int kbRead
    property int kbWritten
    property int storageUsed
    property int storageTotal
    property real storagePercent

    function formatKB(kb: real): string {
        const mb = 1000;
        const gb = 1000 ** 2;
        const tb = 1000 ** 3;

        if (kb >= tb) {
            return (kb / tb).toFixed(1) + " TB";
        }
        if (kb >= gb) {
            return (kb / gb).toFixed(1) + " GB";
        }
        if (kb >= mb) {
            return (kb / mb).toFixed(1) + " MB";
        }
        return kb.toString() + " KB";
    }

    Timer {
        running: root.inUse
        interval: Settings.map.systemUsageRefreshInterval
        repeat: true
        triggeredOnStart: true
        onTriggered: stats.running = true;
    }

    Process {
        id: stats

        command: [Quickshell.shellDir + "/src/qs-system-usage"]
        stdout: StdioCollector {
            onStreamFinished: {
                const values = text.trim().split('\n').map(function (x) {
                    return parseInt(x, 10);
                });

                const idleDiff = values[0] - lastCpuIdle;
                const totalDiff = values[1] - lastCpuTotal;
                cpuPercent = (totalDiff - idleDiff) / totalDiff;
                lastCpuIdle = values[0];
                lastCpuTotal = values[1];
                cpuTemp = values[2] / 1000.0;

                gpuPercent = values[3] / 1000.0;
                gpuTemp = values[4] / 1000.0;

                memUsed = values[5];
                memTotal = values[6];
                memPercent = values[7] / 1000.0;

                diskId = values[8];
                kbRead = values[9];
                kbWritten = values[10];
                storageUsed = values[11];
                storageTotal = values[12];
                storagePercent = values[13] / 1000.0;
            }
        }
    }
}
