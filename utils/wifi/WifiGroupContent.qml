import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Networking
import qs.config
import qs.services
import qs.utils

Item {
    id: root
    implicitHeight: childrenRect.height

    required property var network
    property bool connected
    property string ssid

    property string status: {
        switch (network?.state) {
            case NetworkState.Unknown:
                return "Unknown State";
            case NetworkState.Disconnecting:
                return "Disconnecting";
            case NetworkState.Connecting:
                return "Connecting";
        }
        return "";
    }

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
                root.network.disconnect();
                return;
            }

            if (root.network.known) {
                root.network.connect();
            } else {
                attemptPasswordConnect.running = true;
            }
        }
    }

    Rectangle {
        id: passwordBackground
        visible: !root.connected && !root.network?.known

        anchors.left: parent.left
        anchors.right: connectionButton.left
        anchors.rightMargin: Style.spacing.normal

        implicitHeight: connectionButton.background.implicitHeight

        color: Style.color.base.base
        radius: height

        TextInput {
            id: passwordBox
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10

            renderType: Text.NativeRendering
            clip: true
            focus: root.visible
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
    }

    Process {
        id: attemptPasswordConnect
        command: ["nmcli", "device", "wifi", "connect", `${root.ssid}`, "password", `${passwordBox.text}`]
        stderr: StdioCollector {
            onStreamFinished: {
                if (text.toLowerCase().includes("error")) {
                    console.warn("Failed to connect to " + root.ssid);
                    console.warn(text);
                }
            }
        }
    }
}
