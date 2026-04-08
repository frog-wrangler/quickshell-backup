pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: root

    property bool inUse: false

    property real cpuPercent
    property real cpuTemp
    property string fanSpeed
    property real gpuPercent
    property real gpuTemp
    property real memUsed
    property real memTotal
    property real memPercent: memTotal ? memUsed / memTotal : 0.0
    property real storageUsed
    property real storageTotal
    property string storagePercent

    property real lastCpuIdle
    property real lastCpuTotal

    function formatKib(kib: real): var {
        const mib = 1024;
        const gib = 1024 ** 2;
        const tib = 1024 ** 3;

        if (kib >= tib) {
            return {
                value: kib / tib,
                unit: "TiB"
            };
        }
        if (kib >= gib) {
            return {
                value: kib / gib,
                unit: "GiB"
            };
        }
        if (kib >= mib) {
            return {
                value: kib / mib,
                unit: "MiB"
            };
        }
        return {
            value: kib,
            unit: "KiB"
        };
    }

    Timer {
        running: root.inUse
        interval: Settings.map.systemUsageRefreshInterval
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            stat.reload();
            meminfo.reload();
            storage.running = true;
            gpuUsage.running = true;
            sensors.running = true;
        }
    }

    FileView {
        id: stat

        path: "/proc/stat"
        onLoaded: {
            const data = text().match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);
            if (data) {
                const stats = data.slice(1).map(n => parseInt(n, 10));
                const total = stats.reduce((a, b) => a + b, 0);
                const idle = stats[3] + (stats[4] ?? 0);

                const totalDiff = total - root.lastCpuTotal;
                const idleDiff = idle - root.lastCpuIdle;
                root.cpuPercent = totalDiff > 0 ? (1 - idleDiff / totalDiff) : 0;

                root.lastCpuTotal = total;
                root.lastCpuIdle = idle;
            }
        }
    }

    FileView {
        id: meminfo

        path: "/proc/meminfo"
        onLoaded: {
            const data = text();
            root.memTotal = parseInt(data.match(/MemTotal: *(\d+)/)[1], 10) || 1;
            root.memUsed = (root.memTotal - parseInt(data.match(/MemAvailable: *(\d+)/)[1], 10)) || 0;
        }
    }

    Process {
        id: storage

        command: ["sh", "-c", "df | grep '^/dev/nvme'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = text.trim().split(/\s+/);

                if (parts.length > 0) {
                    root.storageTotal = parts[1];
                    root.storageUsed = parts[2];
                    root.storagePercent = parts[4];
                }
            }
        }
    }

    Process {
        id: gpuUsage

        command: ["sh", "-c", "cat /sys/class/drm/card*/device/gpu_busy_percent"]
        stdout: StdioCollector {
            onStreamFinished: {
                const percent = text.trim().split("\n");
                const sum = percent.reduce((acc, d) => acc + parseInt(d, 10), 0);
                root.gpuPercent = sum / percent.length / 100;
            }
        }
    }

    Process {
        id: sensors

        command: ["sensors"]
        environment: ({
                LANG: "C",
                LC_ALL: "C"
            })
        stdout: StdioCollector {
            onStreamFinished: {
                let cpuTemp = text.match(/(?:Package id [0-9]+|Tdie):\s+((\+|-)[0-9.]+)(°| )C/);
                if (!cpuTemp)
                    // If AMD Tdie pattern failed, try fallback on Tctl
                    cpuTemp = text.match(/Tctl:\s+((\+|-)[0-9.]+)(°| )C/);

                if (cpuTemp)
                    root.cpuTemp = parseFloat(cpuTemp[1]);

                let eligible = false;
                let sum = 0;
                let count = 0;

                for (const line of text.trim().split("\n")) {
                    if (line === "Adapter: PCI adapter")
                        eligible = true;
                    else if (line === "")
                        eligible = false;
                    else if (eligible) {
                        let match = line.match(/^(temp[0-9]+|GPU core|edge)+:\s+\+([0-9]+\.[0-9]+)(°| )C/);
                        if (!match)
                            // Fall back to junction/mem if GPU doesn't have edge temp (for AMD GPUs)
                            match = line.match(/^(junction|mem)+:\s+\+([0-9]+\.[0-9]+)(°| )C/);

                        if (match) {
                            sum += parseFloat(match[2]);
                            count++;
                        }
                    }
                }

                root.gpuTemp = count > 0 ? sum / count : 0;
                // root.fanSpeed = text.match(/fan\d+:\s+(\d+)\s+RPM/)[1] + " RPM"; // TODO
            }
        }
    }
}
