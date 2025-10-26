import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.config

Item {
    id: root

    required property ShellScreen screen

    anchors.fill: parent

    ClippingWrapperRectangle {
        topLeftRadius: Style.rounding.large
        topRightRadius: Style.rounding.large

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        height: screen.height - Style.size.barSize

        Image {
            id: current
            source: DesktopBackground.wallpaperPath

            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }
    }
}
