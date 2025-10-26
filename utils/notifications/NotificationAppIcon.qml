pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.config

Rectangle {
    id: root

    property string image: ""
    property string appIcon: ""

    readonly property int size: Style.size.notificationAppIcon
    width: size
    height: size
    radius: size / 2
    color: Style.color.base.overlay

    Loader {
        id: appIconLoader
        active: root.appIcon != ""
        anchors.centerIn: parent
        sourceComponent: IconImage {
            implicitSize: root.size - Style.spacing.small * 2
            asynchronous: true
            source: Quickshell.iconPath(root.appIcon)
        }
    }

    Loader {
        id: imageLoader
        active: root.image != ""
        anchors.fill: parent
        sourceComponent: Image {
            anchors.fill: parent

            source: root.image
            fillMode: Image.PreserveAspectCrop
            cache: false
            antialiasing: true
            asynchronous: true

            width: root.size
            height: root.size
            sourceSize.width: root.size
            sourceSize.height: root.size
        }
    }
}
