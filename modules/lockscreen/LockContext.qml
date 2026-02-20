import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root
    signal unlocked
    signal failedFingerprint
    signal failedPassword

    property bool fingerprintInProgress: false
    property string tempPasswordAttempt: ""

    function tryPassword(pass): void {
        if (pass == "")
            return;
        root.tempPasswordAttempt = pass;

        pamPassword.start();
    }

    function startFingerprint(): void {
        root.fingerprintInProgress = true;
        pamFingerprint.start();
    }

    PamContext {
        id: pamPassword
        configDirectory: "pam"
        config: "password.conf"

        onResponseRequiredChanged: {
            if (responseRequired) {
                respond(root.tempPasswordAttempt);
                root.tempPasswordAttempt = "";
            }
        }

        onCompleted: result => {
            if (result == PamResult.Success) {
                root.unlocked();
            } else {
                root.failedPassword();
            }
        }
    }

    PamContext {
        id: pamFingerprint
        configDirectory: "pam"
        config: "fingerprint.conf"

        onCompleted: result => {
            if (result == PamResult.Success) {
                root.unlocked();
            } else {
                root.failedFingerprint();
            }

            root.fingerprintInProgress = false;
        }
    }
}
