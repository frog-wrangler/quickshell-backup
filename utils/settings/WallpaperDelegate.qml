import QtQuick
import Quickshell
import qs.utils

Item {
    id: fileDelegate
    required property var modelData
    height: 200
    width: 200

    Rectangle {
        anchors.fill: parent
        border.width: 5
    }

    StyledText {
        id: label
        anchors.top: fileDelegate.top
        anchors.horizontalCenter: fileDelegate.horizontalCenter

        text: modelData.fileName
    }

    Image {
        id: image
        anchors.top: label.bottom
        anchors.horizontalCenter: fileDelegate.horizontalCenter
        height: 70
        width: 120
        sourceSize.height: height * 2
        sourceSize.width: width * 2

        asynchronous: true
        source: modelData.filePath

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                Quickshell.execDetached(["qs", "ipc", "call", "background", "setWallpaper", modelData.filePath]);
            }
        }
    }
}
