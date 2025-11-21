import QtQuick
import qs.config
import qs.utils
import qs.modules.background

MouseArea {
    id: root
    anchors.fill: parent

    required property LockContext context
    property bool tryPassword: false

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton
    onPressed: mouse => {
        forceFieldFocus();
    }
    onPositionChanged: mouse => {
        forceFieldFocus();
    }

    function forceFieldFocus(): void {
        passwordBox.forceActiveFocus();
    }

    Component.onCompleted: {
        forceFieldFocus();
    }

    Image {
        id: background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: DesktopBackground.lockscreenWallpaperPath
    }

    Loader {
        active: DesktopBackground.showClockOnLockscreen
        sourceComponent: DesktopClock {
            parent: root

            readonly property string pos: DesktopBackground.lockscreenClockPosition

            anchors {
                top: pos == "topLeft" || pos == "topRight" ? parent.top : undefined
                bottom: pos == "bottomLeft" || pos == "bottomRight" ? parent.bottom : undefined
                left: pos == "topLeft" || pos == "bottomLeft" ? parent.left : undefined
                right: pos == "topRight" || pos == "bottomRight" ? parent.right : undefined
            }
        }
    }

    Connections {
        target: root.context

        function onFailedFingerprint() {
            root.tryPassword = true;
        }
        function onFailedPassword() {
            root.tryPassword = false;
        }
        function onShouldReFocus() {
            root.forceFieldFocus();
        }
    }

    QuickButton {
        id: startPamButton
        anchors.centerIn: parent

        iconName: "lock"
        backgroundColor: Style.color.base.surface1
        hoverColor: Style.color.accent.current
        size: Style.size.lockscreenButtonSize
        radius: size / 2

        onClicked: {
            root.context.startAttempt();
        }
    }

    Rectangle {
        id: attemptStartText
        visible: root.context.unlockInProgress
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: startPamButton.bottom
        anchors.topMargin: Style.spacing.large * 2

        implicitHeight: text.implicitHeight + 5
        implicitWidth: text.implicitWidth + 20

        color: Style.color.base.surface1
        radius: implicitHeight / 2

        StyledText {
            id: text
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            text: root.tryPassword ? Style.choice.fingerprintFailure : Style.choice.unlockStartMessage
            font.pointSize: Style.font.size.normal
        }
    }

    Rectangle {
        id: passwordBoxContainer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Style.spacing.extraLarge

        visible: root.tryPassword

        radius: height / 2
        color: Style.color.base.surface0
        implicitHeight: Style.size.passwordBoxHeight
        implicitWidth: Style.size.passwordBoxWidth

        TextInput {
            id: passwordBox
            anchors.fill: parent
            anchors.margins: 10

            renderType: Text.NativeRendering
            clip: true
            focus: true
            onFocusChanged: root.forceFieldFocus()
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

            // enabled: !root.context.unlockInProgress
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData

            onTextChanged: root.context.currentText = this.text
            onAccepted: root.context.tryPassword()
            Connections {
                target: root.context
                function onCurrentTextChanged() {
                    passwordBox.text = root.context.currentText;
                }
            }
        }
    }
}
