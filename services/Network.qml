pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: root

    readonly property list<AccessPoint> networks: []
    property list<string> autoSsidList: []
    property list<string> ssidList: []
    property var groupBySsid: {}

    readonly property AccessPoint active: networks.find(n => n.active) ?? null
    property string pinnedSsid: ""

    reloadableId: "network"

    function pin(ssid): void {
        pinnedSsid = ssid;
    }

    function addAuto(ssid): void {
        autoSsidList.push(ssid);
    }

    function refresh(): void {
        getNetworks.running = true;
    }

    function refreshSsids(): void {
        ssidList = Object.keys(groupBySsid).sort((a, b) => {
            return groupBySsid[b].strength - groupBySsid[a].strength;
        });
    }
    
    function refreshGroups(): void {
        const groups = {}
        networks.forEach((network) => {
            if (!groups[network.ssid]) {
                groups[network.ssid] = {
                    ssid: network.ssid,
                    accessPoints: [],
                    strength: network.strength
                }
            }
            groups[network.ssid].accessPoints.push(network);
            groups[network.ssid].strength = Math.max(groups[network.ssid].strength, network.strength);
        });
        root.groupBySsid = groups;
        refreshSsids();
    }

    Process {
        running: true
        command: ["nmcli", "m"]
        stdout: SplitParser {
            onRead: root.refresh();
        }
    }

    Process {
        id: getAutoSsids
        running: true
        command: ["nmcli", "-g", "NAME", "c"]
        stdout: SplitParser {
            onRead: data => {
                const name = data.trim();
                if (name != "") {
                    root.autoSsidList.push(name);
                }
            }
        }
    }

    Process {
        id: getNetworks
        running: true
        command: ["nmcli", "-g", "ACTIVE,SIGNAL,FREQ,SSID,BSSID", "d", "w"]
        environment: ({
            LANG: "C",
            LC_ALL: "C"
        })
        stdout: StdioCollector {
            onStreamFinished: {
                const PLACEHOLDER = "STRINGWHICHHOPEFULLYNOTBEUSEDPLS";
                const rep = new RegExp("\\\\:", "g");
                const rep2 = new RegExp(PLACEHOLDER, "g");

                if (!text.trim()) {
                    console.warn("Empty output from nmcli, skipping parse.");
                    return;
                }

                const networks = text.trim().split("\n").map(n => {
                    const net = n.replace(rep, PLACEHOLDER).split(":");
                    return {
                        active: net[0] === "yes",
                        strength: parseInt(net[1]),
                        frequency: parseInt(net[2]),
                        ssid: net[3] || "nossid",
                        bssid: net[4]?.replace(rep2, ":") ?? ""
                    };
                }).filter(n => {
                    if (Style.choice.hideNoSsid && n.ssid == "nossid") return false;
                    return true;
                });
                const rNetworks = root.networks;
                
                const destroyed = rNetworks.filter(rn => !networks.find(n => n.frequency === rn.frequency && n.ssid === rn.ssid && n.bssid === rn.bssid));
                for (const network of destroyed)
                    rNetworks.splice(rNetworks.indexOf(network), 1).forEach(n => n.destroy());

                for (const network of networks) {
                    const match = rNetworks.find(n => n.frequency === network.frequency && n.ssid === network.ssid && n.bssid === network.bssid);
                    if (match) {
                        match.lastIpcObject = network;
                    } else {
                        if (network && network.ssid) {
                            const ap = apComp.createObject(root, {
                                lastIpcObject: network
                            });
                            if (ap === null) {
                                console.error("Failed to create access point: ", network);
                            } else {
                                rNetworks.push(ap);
                            }
                        } else {
                            console.warn("Skipped malformed network:", JSON.stringify(network, null, 2));
                        }
                    }
                }

                root.refreshGroups();
            }
        }
    }

    component AccessPoint: QtObject {
        required property var lastIpcObject
        readonly property string ssid: lastIpcObject.ssid
        readonly property string bssid: lastIpcObject.bssid
        readonly property int strength: lastIpcObject.strength
        readonly property int frequency: lastIpcObject.frequency
        readonly property bool active: lastIpcObject.active
    }

    Component {
        id: apComp

        AccessPoint {}
    }
}
