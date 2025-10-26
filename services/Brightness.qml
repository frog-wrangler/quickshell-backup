pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real brightness: 0

    function update(): void {
        updateBrightness.running = true;
    }

    Process {
        id: updateBrightness
        running: true
        command: ["sh", "-c", "echo $(brightnessctl get) $(brightnessctl max)"]
        stdout: SplitParser {
            onRead: data => {
                const nums = data.trim().split(" ");
                root.brightness = nums[0] / nums[1];
            }
        }
    }

    function setBrightness(brightness: real): void {
        const rounded = Math.round(brightness * 100);
        Quickshell.execDetached(["brightnessctl", "s", `${rounded}%`]);
    }

    signal changed(newBrightness: real)
    onBrightnessChanged: {
        changed(brightness);
    }
}
