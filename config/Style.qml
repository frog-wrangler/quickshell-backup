pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property Choice choice: Choice {}
    readonly property Color color: Color {}
    readonly property Rounding rounding: Rounding {}
    readonly property Spacing spacing: Spacing {}
    readonly property Size size: Size {}
    readonly property Font font: Font {}
    readonly property Anim anim: Anim {}

    component Choice: QtObject {
        readonly property bool showBluetoothInTray: false
        readonly property bool lockedOnBoot: true
        readonly property bool hideNoSsid: true
        readonly property bool topBarShowDate: true
        readonly property bool wallpaperUnderTopBar: true

        readonly property int wifiListRefreshInterval: 10000
        readonly property int wifiIconRefreshInterval: 2000
        readonly property int systemUsageRefreshInterval: 2000

        readonly property string unlockStartMessage: "Unlock Attempt Started"
        readonly property string fingerprintFailure: "Fingerprint Failed"
        readonly property string noNotificationText: "No Notifications"
    }

    component Color: QtObject {
        readonly property ColorBase base: ColorBase {}
        readonly property ColorAccent accent: ColorAccent {}
    }

    component ColorBase: QtObject {
        readonly property color crust: "#11111b"
        readonly property color mantle: "#181825"
        readonly property color base: "#1e1e2e"
        readonly property color surface0: "#313244"
        readonly property color surface1: "#585b70"
        readonly property color overlay: "#7f849c"
        readonly property color subtext: "#a6adc8"
        readonly property color text: "#cdd6f4"
    }

    component ColorAccent: QtObject {
        property color current: muave
        readonly property color pink: "#f5c2e7"
        readonly property color muave: "#cba6f7"
        readonly property color lavender: "#b4befe"
        readonly property color blue: "#89b4fa"
        readonly property color teal: "#94e2d5"
        readonly property color green: "#a6e3a1"
        readonly property color yellow: "#f9e2af"
        readonly property color orange: "#fab387"
        readonly property color red: "#e05c7b"
    }

    component Rounding: QtObject {
        readonly property int small: 8
        readonly property int normal: 12
        readonly property int large: 20
        readonly property int extraLarge: 50
    }

    component Spacing: QtObject {
        readonly property int extraSmall: 4
        readonly property int small: 7
        readonly property int normal: 12
        readonly property int large: 15
        readonly property int extraLarge: 20
    }

    component Size: QtObject {
        readonly property int barSize: 40
        readonly property int topBarMargin: 6
        readonly property int statusSize: 450
        readonly property int lockscreenButtonSize: 50
        readonly property int passwordBoxWidth: 180
        readonly property int passwordBoxHeight: 44
        readonly property int statusPanelTabFooter: 40
        readonly property int noNotificationHeight: 80
        readonly property int statusPanelTabBarHeight: 50
        readonly property int systemTrayItem: 30
        readonly property int bluetoothItemMinSize: 40
        readonly property int notificationAppIcon: 50
        readonly property int wifiGroupHeight: 60
        readonly property int dockIcon: 48
    }

    component Font: QtObject {
        readonly property FontSize size: FontSize {}
        readonly property FontFamily family: FontFamily {}
    }

    component FontSize: QtObject {
        readonly property int small: 10
        readonly property int normal: 12
        readonly property int large: 16
        readonly property int extraLarge: 20
        readonly property int huge: 55
    }

    component FontFamily: QtObject {
        readonly property string clock: "Outfit ExtraBold"
        readonly property string mono: "JetBrains Mono NF"
        readonly property string serif: "Liberation Serif"
        readonly property string icons: "Material Symbols Rounded"
    }

    component Anim: QtObject {
        readonly property AnimCurves curves: AnimCurves {}
        readonly property AnimDurations durations: AnimDurations {}
    }

    component AnimCurves: QtObject {
        readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
    }

    component AnimDurations: QtObject {
        readonly property int tiny: 40
        readonly property int small: 200
        readonly property int normal: 400
        readonly property int large: 600
        readonly property int extraLarge: 1000
    }
}
