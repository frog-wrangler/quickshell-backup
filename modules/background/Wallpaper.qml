import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.config

Item {
    id: root

    required property ShellScreen screen

    anchors.fill: parent
    anchors.topMargin: Style.size.barSize

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
            source: DesktopBackground.wallpaperPath

            anchors.fill: parent
            anchors.topMargin: (Style.choice.wallpaperUnderTopBar ? -Style.size.barSize : 0)
            fillMode: Image.PreserveAspectCrop
        }
    }
}
