import Quickshell
import QtQuick

import qs.config
import qs.services

import qs.modules.background
import qs.modules.bar
import qs.modules.idler
import qs.modules.lockscreen
import qs.modules.widgets.dashboard
import qs.modules.widgets.statuspanel
import qs.modules.widgets.notifications

ShellRoot {
    Bar {}
    Background {}
    Lock {}

    Dashboard {}
    StatusPanel {}

    Loader {
        active: Settings.map.idleOn
        sourceComponent: Idle {}
    }

    Loader {
        active: Settings.map.notificationPopups
        sourceComponent: PopupList {}
    }
}
