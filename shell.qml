import Quickshell
import QtQuick
import qs.config
import qs.modules.background
import qs.modules.bar
import qs.modules.idler
import qs.modules.lockscreen

ShellRoot {
    Bar {}
    Background {}
    Lock {}

    Loader {
        active: SettingsConfig.idleActive
        sourceComponent: Idle {}
    }
}
