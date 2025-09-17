import QtQuick
import Quickshell
import Quickshell.Services.Pam
import "root:/services"

Scope {
    id: root
    signal shouldReFocus()
    signal unlocked()
    signal failedFingerprint()
    signal failedPassword()

    property string currentText: ""
    property bool unlockInProgress: false

    function tryPassword(): void {
        if (currentText == "") return;

        pam.respond(currentText);
    }

    function startAttempt(): void {
        root.unlockInProgress = true;
        pam.start();
    }

    PamContext {
        id: pam
        configDirectory: "pam"
        config: "password.conf"

        onPamMessage: {
            if (this.responseRequired) {
                root.failedFingerprint();
            }
        }

        onCompleted: result => {
            if (result == PamResult.Success) {
                root.unlocked();
            } else {
                root.failedPassword();
            }

            root.currentText = "";
            root.unlockInProgress = false;
        }
    }
}
