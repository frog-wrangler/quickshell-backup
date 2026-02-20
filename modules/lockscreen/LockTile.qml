import QtQuick
import Quickshell.Widgets
import Quickshell.Io
import qs.config
import qs.utils

Item {
    id: root
    height: 450
    width: 350

    required property LockContext context

    property string username: ""

    Process {
        running: true
        command: ["sh", "-c", "echo $USER"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.username = this.text;
            }
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        opacity: 0.5
        color: Style.color.base.mantle
        radius: Style.rounding.normal
    }

    ClippingRectangle {
        id: userImage
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30
        height: 120
        width: height
        radius: height / 4

        border.width: 2
        border.color: Style.color.base.surface1

        Image {
            anchors.fill: parent
            source: "root:/data/frog_cowboy.jpg"
            fillMode: Image.PreserveAspectCrop
        }
    }

    // Username and Password
    readonly property int boxHeight: 40

    Rectangle {
        id: username
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: userImage.bottom
        anchors.margins: Style.spacing.extraLarge * 2
        anchors.topMargin: Style.spacing.extraLarge
        height: root.boxHeight

        opacity: 0.7
        radius: root.boxHeight
        color: Style.color.base.surface1

        StyledText {
            anchors.centerIn: parent
            text: root.username
        }
    }

    Rectangle {
        id: passwordBoxBackground
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: username.bottom
        anchors.margins: Style.spacing.extraLarge * 2
        anchors.topMargin: Style.spacing.large
        height: root.boxHeight

        opacity: 0.7
        radius: root.boxHeight
        color: Style.color.base.surface0

        border.width: 2
        border.color: Style.color.base.surface1

        TextInput {
            id: passwordBox
            anchors.fill: parent
            anchors.margins: 10

            renderType: Text.NativeRendering
            clip: true
            focus: true
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            font {
                family: Style.font.family.mono
                pointSize: Style.font.size.normal
                hintingPreference: Font.PreferFullHinting
            }

            selectedTextColor: Style.color.base.surface1
            selectionColor: Style.color.accent.current
            color: Style.color.base.text

            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData

            onAccepted: {
                console.log("Attempting password");
                root.context.tryPassword(text);
                text = "";
            }
        }

        MaterialIcon {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: Style.spacing.normal
            text: "lock"
            color: Style.color.base.text
            size: parent.height / 2.5
        }
    }

    // Fingerprint
    Rectangle {
        id: fingerprintBackground
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40

        height: Style.size.lockscreenButtonSize
        width:Style.size.lockscreenButtonSize 
        radius: height / 2
        color: Style.color.base.surface0

        MaterialIcon {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: Style.size.lockscreenButtonSize

            text: "lock_open"
            size: Style.font.size.large
            color: Style.color.base.text
        }

        QuickButton {
            id: fingerprintButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left

            iconName: "fingerprint"
            backgroundColor: Style.color.base.surface1
            hoverColor: Style.color.accent.current
            size: Style.size.lockscreenButtonSize
            radius: size / 2

            onClicked: {
                root.context.startFingerprint();
            }
        }

        states: State {
            name: "attempting"
            when: root.context.fingerprintInProgress
            PropertyChanges {
                target: fingerprintBackground
                width: Style.size.lockscreenButtonSize * 2
            }
        }

        transitions: Transition {
            NumberAnimation {
                properties: "width"
                easing.type: Easing.InOutQuad
            }
        }
    }
}
