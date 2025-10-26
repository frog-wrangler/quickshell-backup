import QtQuick
import QtQuick.Controls
import Quickshell.Io
import qs.config
import qs.services
import qs.utils

Item {
    id: root
    implicitHeight: childrenRect.height

    required property string ssid
    required property bool expanded
    required property bool connected

    property string status: ""

    visible: expanded

    Button {
        id: connectionButton
        anchors.right: parent.right
        anchors.top: parent.top

        background: Rectangle {
            implicitHeight: 30
            implicitWidth: connectButtonText.implicitWidth + 30

            color: Style.color.base.surface1
            radius: Style.rounding.small

            StyledText {
                id: connectButtonText
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                text: root.connected ? "Disconnect" : "Connect"
            }
        }

        onClicked: {
            if (root.connected) {
                attemptDisconnect.running = true;
                return;
            }

            if (Network.autoSsidList.includes(root.ssid)) {
                attemptAutoConnect.running = true;
            } else {
                attemptPasswordConnect.running = true;
            }
        }
    }

    Rectangle {
        id: passwordBackground
        visible: !root.connected && !Network.autoSsidList.includes(root.ssid)

        anchors.left: parent.left
        anchors.right: connectionButton.left
        anchors.rightMargin: Style.spacing.normal

        implicitHeight: connectionButton.background.implicitHeight

        color: Style.color.base.base
        radius: height

        TextInput { // TODO: fix this ?? maybe ??
            id: passwordBox
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10

            renderType: Text.NativeRendering
            clip: true
            focus: root.expanded
            verticalAlignment: TextInput.AlignVCenter
            font {
                family: Style.font.family.mono
                pointSize: Style.font.size.small
                hintingPreference: Font.PreferFullHinting
            }

            selectedTextColor: Style.color.base.surface1
            selectionColor: Style.color.accent.current
            color: Style.color.base.text

            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData

            onAccepted: {
                if (text != "")
                    attemptPasswordConnect.running = true;
            }
        }
    }

    StyledText {
        id: statusText
        height: root.status == "" ? 0 : undefined

        property alias isUnder: passwordBackground.visible
        anchors.top: isUnder ? passwordBackground.bottom : root.top
        anchors.left: parent.left
        anchors.topMargin: isUnder ? Style.spacing.normal : (passwordBackground.implicitHeight - implicitHeight) / 2

        text: root.status
        // - Connecting...
        // - Disconnecting...
        // - Connection Failed
        // - Authentication Failed
    }

    Process {
        id: attemptDisconnect
        command: ["nmcli", "c", "down", `${root.ssid}`]
        onStarted: {
            root.status = "Disconnecting...";
        }
        stderr: StdioCollector {
            onStreamFinished: {
                if (text.toLowerCase().includes("error")) {
                    console.warn("Failed to disconnect from " + root.ssid);
                    console.warn(text);
                    root.status = "Disconnection Failed";
                } else {
                    root.status = "";
                }
            }
        }
    }

    Process {
        id: attemptAutoConnect
        command: ["nmcli", "device", "wifi", "connect", `${root.ssid}`]
        onStarted: {
            root.status = "Connecting...";
        }
        stderr: StdioCollector {
            onStreamFinished: {
                if (text.toLowerCase().includes("error")) {
                    console.warn("Failed to connect to " + root.ssid);
                    console.warn(text);
                    root.status = "Connection Failed";
                } else {
                    root.status = "";
                }
            }
        }
    }

    Process {
        id: attemptPasswordConnect
        command: ["nmcli", "device", "wifi", "connect", `${root.ssid}`, "password", `${passwordBox.text}`]
        onStarted: {
            root.status = "Connecting...";
        }
        stderr: StdioCollector {
            onStreamFinished: {
                if (text.toLowerCase().includes("error")) {
                    console.warn("Failed to connect to " + root.ssid);
                    console.warn(text);
                    root.status = "Authentication Failed";
                } else {
                    root.status = "";
                    Network.addAuto(root.ssid);
                }
            }
        }
    }
}
