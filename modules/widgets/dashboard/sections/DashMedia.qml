import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import qs.config
import qs.utils
import qs.services

Rectangle {
    id: root
    visible: Players.active != null

    height: 110
    radius: Style.rounding.small
    color: Style.color.base.surface0

    property real progress: {
        const active = Players.active;
        return active?.length ? active.position / active.length : 0;
    }

    Timer {
        running: Players.active?.isPlaying ?? false
        interval: 1000
        triggeredOnStart: true
        repeat: true
        onTriggered: Players.active?.positionChanged()
    }

    function lengthString(length: int): string {
        if (length <= 0)
            return "0:00";

        const hours = Math.floor(length / 3600);
        const minutes = Math.floor((length % 3600) / 60);
        const seconds = (length % 60).toString().padStart(2, "0");

        if (hours > 0) {
            return `${hours}:${minutes.toString().padStart(2, "0")}:${seconds}`;
        }
        return `${minutes}:${seconds}`;
    }

    //
    // Visuals
    //
    ClippingWrapperRectangle {
        id: trackArt
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 8

        readonly property int size: 90
        implicitHeight: size
        implicitWidth: size
        radius: Style.rounding.normal

        color: Style.color.base.surface0
        border.width: 2
        border.color: Style.color.base.surface1

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
        size: Style.font.size.extraLarge
    }

    ElidedText {
        id: title
        anchors.top: parent.top
        anchors.left: trackArt.right
        anchors.right: playButton.left
        anchors.margins: 10

        text: Players.active?.trackTitle || "Unknown Track"
        color: Style.color.accent.current
        font.pointSize: Style.font.size.small
        font.bold: true
    }

    StyledText {
        id: timeLabel
        anchors.top: title.bottom
        anchors.left: trackArt.right
        anchors.margins: 10

        text: root.lengthString(Players.active?.position ?? 0) + " / " + root.lengthString(Players.active?.length ?? 0)
    }

    Button {
        id: playButton
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 10

        implicitWidth: 50
        implicitHeight: implicitWidth

        contentItem: MaterialIcon {
            text: Players.active?.isPlaying ? "pause" : "play_arrow"
            color: Style.color.base.base
            size: Style.font.size.large

            width: height
        }

        background: Rectangle {
            id: background
            color: Style.color.accent.current

            implicitWidth: parent.implicitWidth
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

    RowLayout {
        anchors.left: trackArt.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10

        QuickButton {
            iconName: "skip_previous"
            size: 30

            onClicked: {
                Players.previous();
            }
        }

        Slider {
            id: slider
            Layout.fillWidth: true

            leftPadding: 10
            rightPadding: 10

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

        QuickButton {
            iconName: "skip_next"
            size: 30

            onClicked: {
                Players.next();
            }
        }
    }

    component ElidedText: StyledText {
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignLeft

        elide: Text.ElideRight
    }
}
