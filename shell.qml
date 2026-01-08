import Quickshell
import QtQuick
import qs.config
import qs.modules.background
import qs.modules.bar
import qs.modules.idler
import qs.modules.lockscreen
import qs.modules.widgets.dashboard
import qs.modules.widgets.statuspanel

ShellRoot {
    Bar {}
    Background {}
    Lock {}

    Dashboard {}
    StatusPanel {}

    Loader {
        active: SettingsConfig.idleActive
        sourceComponent: Idle {}
    }
}
