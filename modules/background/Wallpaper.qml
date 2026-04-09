import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config
import qs.services
import qs.utils

Item {
    id: root

    required property ShellScreen screen

    anchors.fill: parent
    anchors.topMargin: Style.size.barSize

    readonly property bool random: Settings.map.wallpaper.toLowerCase() == "random"
    property string randomPath: ""

    Process {
        id: randomWallpaper
        running: root.random
        command: ["sh", "-c", `find ${Quickshell.shellDir}/data/wallpapers/ -type f | shuf -n 1`]
        stdout: SplitParser {
            onRead: path => {
                root.randomPath = path;
            }
        }
    }

    ClippingWrapperRectangle {
        topLeftRadius: Style.rounding.large
        topRightRadius: Style.rounding.large

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        height: root.screen.height - Style.size.barSize

        Image {
            id: current
            source: root.random ? root.randomPath : Settings.map.wallpaper

            anchors.fill: parent
            anchors.topMargin: (Settings.map.wallpaperUnderTopBar ? -Style.size.barSize : 0)
            fillMode: Image.PreserveAspectCrop
        }
    }

    StyledText {
        id: activateLinux
        visible: Settings.map.activateLinux
        anchors.left: goToSettings.left
        anchors.bottom: goToSettings.top
        anchors.bottomMargin: Style.spacing.small

        font.pointSize: Style.font.size.normal
        font.bold: true
        color: Style.color.base.subtext

        text: "Activate Linux"
    }

    StyledText {
        id: goToSettings
        visible: Settings.map.activateLinux
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Style.spacing.extraLarge * 3

        font.pointSize: Style.font.size.normal
        color: Style.color.base.subtext

        text: "Go to Settings to Activate Linux"
    }
}
