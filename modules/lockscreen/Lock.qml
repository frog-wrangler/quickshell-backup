import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.services

Scope {
    id: root

    LockContext {
        id: lockContext

        onUnlocked: {
            GlobalStates.screenLocked = false;
        }
    }

    WlSessionLock {
        id: lock
        locked: GlobalStates.screenLocked;

        WlSessionLockSurface {
            color: "transparent"
            Loader {
                active: GlobalStates.screenLocked
                anchors.fill: parent
                opacity: active ? 1 : 0

                sourceComponent: LockSurface {
                    context: lockContext
                }
            }
        }
    }

    IpcHandler {
        target: "lock"
        function activate(): void {
            GlobalStates.screenLocked = true;
        }

        function focus(): void {
            lockContext.shouldReFocus();
        }
    }
}
