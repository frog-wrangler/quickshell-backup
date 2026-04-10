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

    onModelDataChanged: {
        if (!modelData) return;

        const filename = modelData.fileName;
        label.text = filename.substring(0, filename.lastIndexOf('.')) || filename;
    }

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
        anchors.left: image.left
        anchors.right: image.right

        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter

        text: ""
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
