import QtQuick
import QtQuick.Effects
import qs.config
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
        source: DesktopBackground.wallpaperPath
    }

    MultiEffect {
        source: background
        anchors.fill: background
        blurEnabled: true
        blurMax: 64
        blur: 0.8
    }

    LockTile {
        anchors.centerIn: parent
        context: root.context
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
}
