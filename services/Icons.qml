pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property var categoryIcons: ({
            WebBrowser: "web",
            Printing: "print",
            Security: "security",
            Network: "language",
            Archiving: "archive",
            Compression: "folder_zip",
            Development: "code",
            IDE: "code",
            TextEditor: "text_snippet",
            Audio: "music_note",
            Music: "music_note",
            Player: "music_note",
            Recorder: "mic",
            Game: "stadia_controller",
            FileTools: "folder",
            FileManager: "folder",
            Filesystem: "folder",
            Settings: "settings",
            DesktopSettings: "settings",
            HardwareSettings: "settings",
            TerminalEmulator: "terminal",
            ConsoleOnly: "terminal",
            Utility: "construction",
            Monitor: "monitor_heart",
            Midi: "piano",
            Mixer: "instant_mix",
            AudioVideoEditing: "video_settings",
            AudioVideo: "music_video",
            Video: "videocam",
            Building: "construction",
            Graphics: "photo_library",
            "2DGraphics": "photo_library",
            RasterGraphics: "photo_library",
            TV: "tv",
            System: "dns",
            Office: "content_paste"
        })

    readonly property var weatherIcons: ({
            "113": "clear_day",
            "116": "partly_cloudy_day",
            "119": "cloud",
            "122": "cloud",
            "143": "foggy",
            "176": "rainy",
            "179": "rainy",
            "182": "rainy",
            "185": "rainy",
            "200": "thunderstorm",
            "227": "cloudy_snowing",
            "230": "snowing_heavy",
            "248": "foggy",
            "260": "foggy",
            "263": "rainy",
            "266": "rainy",
            "281": "rainy",
            "284": "rainy",
            "293": "rainy",
            "296": "rainy",
            "299": "rainy",
            "302": "weather_hail",
            "305": "rainy",
            "308": "weather_hail",
            "311": "rainy",
            "314": "rainy",
            "317": "rainy",
            "320": "cloudy_snowing",
            "323": "cloudy_snowing",
            "326": "cloudy_snowing",
            "329": "snowing_heavy",
            "332": "snowing_heavy",
            "335": "snowing",
            "338": "snowing_heavy",
            "350": "rainy",
            "353": "rainy",
            "356": "rainy",
            "359": "weather_hail",
            "362": "rainy",
            "365": "rainy",
            "368": "cloudy_snowing",
            "371": "snowing",
            "374": "rainy",
            "377": "rainy",
            "386": "thunderstorm",
            "389": "thunderstorm",
            "392": "thunderstorm",
            "395": "snowing"
        })

    readonly property var bluetoothIcons: ({
            "audio-headphones": "headphones",
            "audio-headset": "headset_mic",
            "audio-card": "music_note",
            "input-mouse": "mouse",
            "input-gaming": "stadia_controller",
            "input-keyboard-bluetooth": "keyboard",
            "computer": "desktop_windows",
            "phone": "mobile_2",
            "modem": "router",
            "pda": "tablet_android",
            "printer": "print",
            "scanner": "adf_scanner",
            "video-display": "live_tv"
        })

    function getDesktopEntry(name: string): DesktopEntry {
        name = name.toLowerCase().replace(/ /g, "-");
        return DesktopEntries.applications.values.find(n => n.id.toLowerCase() === name) ?? null;
    }

    function getAppCategoryIcon(name: string, fallback: string): string {
        const categories = getDesktopEntry(name)?.categories;

        if (categories)
            for (const [key, value] of Object.entries(categoryIcons))
                if (categories.includes(key))
                    return value;
        return fallback;
    }

    function getBluetoothIcon(systemIcon: string): string {
        if (bluetoothIcons.hasOwnProperty(systemIcon))
            return bluetoothIcons[systemIcon];
        return "question_mark";
    }

    function getWifiIcon(strength: int): string {
        if (strength >= 80)
            return "signal_wifi_4_bar";
        if (strength >= 60)
            return "network_wifi_3_bar";
        if (strength >= 40)
            return "network_wifi_2_bar";
        if (strength >= 20)
            return "network_wifi_1_bar";
        return "signal_wifi_0_bar";
    }

    function getWeatherIcon(code: string): string {
        if (weatherIcons.hasOwnProperty(code))
            return weatherIcons[code];
        return "air";
    }
}
