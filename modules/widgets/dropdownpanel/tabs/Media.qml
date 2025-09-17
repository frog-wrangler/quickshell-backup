import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import "root:/config"
import "root:/services"
import "root:/utils"

Item {
    id: root

    ClippingWrapperRectangle {
        id: trackArt
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20

        readonly property int size: 180
        implicitHeight: size
        implicitWidth: size
        radius: size / 2

        color: Style.color.base.surface0
        border.width: 2
        border.color: Style.color.base.subtext

        Image {
            id: image
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop

            source: Players.active?.trackArtUrl ?? ""
            asynchronous: true
        }
    }

    MaterialIcon {
        anchors.centerIn: trackArt
        visible: image.source == ""

        text: "art_track"
        color: Style.color.base.text
        size: Style.font.size.huge
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        width: 180
        height: 180
        radius: height / 2

        color: Style.color.base.surface0
        border.width: 2
        border.color: Style.color.base.subtext

        Image {
            id: sillyguy
            anchors.fill: parent
            rotation: 500 * root.progress
            
            fillMode: Image.PreserveAspectFit

            source: "root:/data/sillyguys/sillyguy2.png"
            asynchronous: true

            Behavior on rotation {
                Anim {}
            }
        }
    }

    ColumnLayout {
        id: infoColumn
        anchors.centerIn: parent
        width: 250

        spacing: 10

        ElidedText {
            text: (Players.active?.trackTitle ?? "No Media") || "Unknown Track"
            color: Style.color.accent.current
            font.pointSize: Style.font.size.small * 1.2
            font.bold: true
            wrapMode: Text.Wrap
            maximumLineCount: 2
        }

        ElidedText {
            visible: text != ""
            text: (Players.active?.trackAlbum ?? "No Media") || ""
        }

        ElidedText {
            text: (Players.active?.trackArtist ?? "No Media") || "Unknown Artist"
        }

        Slider {
            id: slider
            readonly property int margin: 10

            Layout.topMargin: margin * 3
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            leftPadding: margin
            rightPadding: margin

            value: root.progress
            live: false

            background: Item {
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left

                    implicitHeight: 5
                    implicitWidth: slider.handle.x - 3

                    color: Style.color.accent.current
                    radius: implicitHeight
                    topRightRadius: 1
                    bottomRightRadius: 1
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right

                    implicitHeight: 5
                    implicitWidth: parent.width - slider.handle.implicitWidth - slider.handle.x - 3

                    color: Style.color.base.overlay
                    radius: implicitHeight
                    topLeftRadius: 1
                    bottomLeftRadius: 1
                }
            }

            handle: Rectangle {
                x: slider.visualPosition * slider.width

                implicitWidth: 5
                implicitHeight: 20

                color: Style.color.base.text
                radius: implicitWidth
            }

            onPressedChanged: {
                if (!pressed && Players.active?.canSeek) {
                    const active = Players.active;
                    active.position = slider.value * active.length;
                } 
            }
        }

        Item {
            Layout.fillWidth: true
            implicitHeight: Math.max(position.implicitHeight, length.implicitHeight)

            StyledText {
                id: position
                anchors.left: parent.left

                text: root.lengthString(Players.active?.position ?? -1)
            }

            StyledText {
                id: length
                anchors.right: parent.right

                text: root.lengthString(Players.active?.length ?? -1)
            }
        }

        ButtonGroup {
            id: controls
            Layout.alignment: Qt.AlignHCenter

            spacing: 15
            padding: 0

            QuickButton {
                iconName: "skip_previous"

                onClicked: {
                    Players.previous();
                }
            }
            
            Button {
                contentItem: MaterialIcon {
                    id: buttonIcon
                    text: Players.active?.isPlaying ? "pause" : "play_arrow"
                    color: Style.color.base.base
                    size: Style.font.size.extraLarge * 1.3

                    width: 40
                }

                background: Rectangle {
                    id: background
                    color: Style.color.accent.current

                    implicitWidth: 60
                    implicitHeight: implicitWidth
                    radius: implicitWidth / 2

                    MouseArea {
                        id: mouseArea
                        anchors.centerIn: parent
                        height: parent.height
                        width: height
                        cursorShape: Qt.PointingHandCursor
                    }
                }

                onClicked: {
                    Players.togglePlay();
                }
            }

            QuickButton {
                iconName: "skip_next"

                onClicked: {
                    Players.next();
                }
            }
        }

        ButtonGroup {
            Layout.alignment: Qt.AlignHCenter

            padding: 10
            spacing: 45

            QuickButton {
                iconName: "flip_to_front"
                backgroundColor: Style.color.base.surface0

                onClicked: {
                    if (Players.active?.canRaise) {
                        Players.active?.raise();
                        GlobalStates.dropdownOpen = false;
                    }
                }
            }

            QuickButton {
                iconName: "delete"
                backgroundColor: Style.color.base.surface0

                onClicked: {
                    if (Players.active?.canQuit) {
                        Players.active?.quit();
                        GlobalStates.dropdownOpen = false;
                    }  
                }
            }
        }
    }

    //
    // Backend
    //
    property real progress: {
        const active = Players.active;
        return active?.length ? active.position / active.length : 0;
    }

    Timer {
        running: Players.active?.isPlaying ?? false
        interval: 1000
        triggeredOnStart: true
        repeat: true
        onTriggered: Players.active?.positionChanged();
    }

    function lengthString(length: int): string {
        if (length < 0) return "-1:-1";

        const hours = Math.floor(length / 3600);
        const minutes = Math.floor((length % 3600) / 60);
        const seconds = (length % 60).toString().padStart(2, "0");

        if (hours > 0) {
            return `${hours}:${minutes.toString().padStart(2, "0")}:${seconds}`;
        }
        return `${minutes}:${seconds}`;
    }

    component ElidedText: StyledText {
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter

        elide: Text.ElideRight
    }

    component Anim: NumberAnimation {
        duration: Style.anim.durations.large
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Style.anim.curves.standard
    }
}
