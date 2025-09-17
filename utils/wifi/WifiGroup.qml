import QtQuick
import QtQuick.Controls
import Quickshell.Io
import "root:/config"
import "root:/services"
import "root:/utils"

Item {
    id: root
    implicitHeight: background.implicitHeight

    required property string ssid
    readonly property var group: Network.groupBySsid[ssid]
    readonly property bool connected: Network.active?.ssid == ssid

    property bool expanded: Network.pinnedSsid == ssid

    Rectangle {
        id: background
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: root.expanded ? 60 + expandedContent.implicitHeight : 60

        color: (mouseArea.containsMouse && !root.expanded) ? Style.color.base.surface1 : Style.color.base.surface0
        radius: Style.rounding.small

        Rectangle {
            id: indicator
            visible: root.expanded
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 5

            implicitWidth: 3
            implicitHeight: parent.implicitHeight * 2 / 3
            radius: implicitWidth / 2

            color: Style.color.accent.current
        }
    }

    MaterialIcon {
        id: icon
        anchors.left: parent.left
        anchors.top: parent.top

        text: Icons.getWifiIcon(root.group?.strength ?? 0)
        color: Style.color.base.text
        size: Style.font.size.large

        height: 60
        width: 60
    }

    Column {
        id: title
        anchors.left: icon.right
        anchors.verticalCenter: icon.verticalCenter
        anchors.right: parent.right

        spacing: 3

        StyledText {
            id: name
            anchors.left: parent.left
            text: root.ssid
        }
        
        StyledText {
            id: connectText
            anchors.left: parent.left

            text: root.connected ? "Connected" : ""
            color: Style.color.base.subtext
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: background

        hoverEnabled: true
        cursorShape: root.expanded ? Qt.ArrowCursor : Qt.PointingHandCursor

        onClicked: {
            Network.pin(root.ssid);
        }
    }
    
    Item {
        id: expandedContent
        visible: root.expanded
        anchors.left: icon.right
        anchors.top: icon.bottom
        anchors.right: parent.right
        implicitHeight: visible ? 60 : 0

        Button {
            id: connectionButton
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 20
            
            background: Item {
                implicitHeight: root.expanded ? 30 : 0
                implicitWidth: connectButtonText.implicitWidth + 30

                Rectangle {
                    anchors.fill: parent
                    color: Style.color.base.surface1
                    radius: Style.rounding.small
                }

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
            visible: root.expanded && !Network.autoSsidList.includes(root.ssid)
            anchors.verticalCenter: connectionButton.verticalCenter
            anchors.left: parent.left
            anchors.right: connectionButton.left
            anchors.rightMargin: 20

            implicitHeight: connectionButton.background.implicitHeight
            implicitWidth: 90

            color: Style.color.base.base
            radius: height / 2

            TextInput {
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
                    if (text != "") attemptPasswordConnect.running = true;
                }
            }
        }
    }

    Process {
        id: attemptDisconnect
        command: ["nmcli", "c", "down", `${root.ssid}`]
        stderr: StdioCollector {
            onStreamFinished: {
                if (text.toLowerCase().includes("error")) {
                    console.warn("Failed to disconnect from " + root.ssid);
                }
            }
        }
    }

    Process {
        id: attemptAutoConnect
        command: ["nmcli", "device", "wifi", "connect", `${root.ssid}`]
        stderr: StdioCollector {
            onStreamFinished: {
                if (text.toLowerCase().includes("error")) {
                    console.warn("Failed to connect to " + root.ssid);
                }
            }
        }
    }

    Process {
        id: attemptPasswordConnect
        command: ["nmcli", "device", "wifi", "connect", `${root.ssid}`, "password", `${passwordBox.text}`]
        stderr: StdioCollector {
            onStreamFinished: {
                if (text.toLowerCase().includes("error")) {
                    console.warn("Failed to connect to " + root.ssid);
                } else {
                    Network.addAuto(root.ssid);
                }
            }
        }
    }
}
