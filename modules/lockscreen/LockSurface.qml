import QtQuick
import QtQuick.Effects
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
    onPressed: (mouse) => {
        forceFieldFocus();
    }
    onPositionChanged: (mouse) => {
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
        source: "root:/data/wallpapers/deer_pillars.jpg"
    }
    Loader {
        active: Style.choice.showClockOnLockscreen
        DesktopClock {
            anchors {
                top: parent.top
                left: parent.left
            }
        }
    }

    Connections {
        target: context

        function onFailedFingerprint() {
            root.tryPassword = true;
        }
        function onFailedPassword() {
            root.tryPassword = false;
        }
        function onShouldReFocus() {
            forceFieldFocus();
        }
    }

    QuickButton {
        id: startPamButton
        anchors.centerIn: parent

        iconName: "lock"
        backgroundColor: Style.color.base.surface1
        hoverColor: Style.color.accent.current
        size: 50
        radius: 25

        onClicked: {
            root.context.startAttempt();
        }
    }

    Rectangle {
        id: attemptStartText
        visible: root.context.unlockInProgress
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: startPamButton.bottom
        anchors.topMargin: 30

        implicitHeight: text.implicitHeight + 5
        implicitWidth: text.implicitWidth + 20

        color: Style.color.base.surface1
        radius: implicitHeight / 2

        StyledText {
            id: text
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            text: root.tryPassword ? "Fingerprint failed" : "Unlock attempt started"
            font.pointSize: Style.font.size.normal
        }
    }

    Rectangle {
        id: passwordBoxContainer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20

        visible: root.tryPassword

        radius: height / 2
        color: Style.color.base.surface0
        implicitHeight: 44
        implicitWidth: 160

        TextInput {
            id: passwordBox
            anchors.fill: parent
            anchors.margins: 10

            renderType: Text.NativeRendering
            clip: true
            focus: true
            onFocusChanged: root.forceFieldFocus();
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

            onTextChanged: root.context.currentText = this.text;
            onAccepted: root.context.tryPassword();
            Connections {
                target: root.context
                function onCurrentTextChanged() {
                    passwordBox.text = root.context.currentText;
                }
            }
        }
    }
}
