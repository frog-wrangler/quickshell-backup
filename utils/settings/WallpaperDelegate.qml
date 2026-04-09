import QtQuick
import Quickshell
import qs.config
import qs.utils

Item {
    id: fileDelegate

    required property var modelData

    height: GridView.view.cellHeight
    width: GridView.view.cellWidth
    clip: true

    readonly property int margin: 5

    Rectangle {
        anchors.fill: parent
        anchors.margins: fileDelegate.margin
        color: Style.color.base.base
        radius: Style.rounding.small
    }

    StyledText {
        id: label
        anchors.top: fileDelegate.top
        anchors.topMargin: fileDelegate.margin * 2
        anchors.horizontalCenter: fileDelegate.horizontalCenter

        text: modelData.fileName
    }

    Image {
        id: image
        anchors.top: label.bottom
        anchors.topMargin: fileDelegate.margin
        anchors.horizontalCenter: fileDelegate.horizontalCenter
        height: 70
        width: 120
        sourceSize.height: height * 2
        sourceSize.width: width * 2

        asynchronous: true
        source: modelData.filePath
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            Quickshell.execDetached(["qs", "ipc", "call", "settings", "setString", "wallpaper", modelData.filePath]);
        }
    }
}
