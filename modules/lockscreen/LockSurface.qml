import QtQuick
import QtQuick.Effects
import qs.config
import qs.services
import qs.utils
import qs.modules.background

MouseArea {
    id: root
    anchors.fill: parent

    required property LockContext context

    // For input absorbtion
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton

    // For Visuals
    Image {
        id: background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: Settings.map.wallpaper
    }

    MultiEffect {
        source: background
        anchors.fill: background
        anchors.margins: -20
        blurEnabled: true
        blurMax: 64
        blur: 0.8
    }

    LockTile {
        anchors.centerIn: parent
        context: root.context
    }

    Loader {
        active: Settings.map.clockOnLockscreen
        sourceComponent: DesktopClock {
            parent: root

            readonly property string pos: Settings.map.lockscreenClockPosition

            anchors {
                top: pos == "topLeft" || pos == "topRight" ? parent.top : undefined
                bottom: pos == "bottomLeft" || pos == "bottomRight" ? parent.bottom : undefined
                left: pos == "topLeft" || pos == "bottomLeft" ? parent.left : undefined
                right: pos == "topRight" || pos == "bottomRight" ? parent.right : undefined
            }
        }
    }
}
