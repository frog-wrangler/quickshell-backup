pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real brightness: 0
    signal changed(newBrightness: real)

    function update(): void {
        updateBrightness.running = true;
    }

    function setBrightness(br: real): void {
        const rounded = Math.round(br * 100);
        Quickshell.execDetached(["brightnessctl", "s", `${rounded}%`]);
        root.brightness = br;
        changed(br);
    }

    Process {
        id: updateBrightness
        running: true
        command: ["sh", "-c", "echo $(brightnessctl get) $(brightnessctl max)"]
        stdout: SplitParser {
            onRead: data => {
                const nums = data.trim().split(" ");
                root.brightness = nums[0] / nums[1];
                root.changed(root.brightness);
            }
        }
    }
}
