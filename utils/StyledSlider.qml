import QtQuick
import QtQuick.Controls
import qs.config

Slider {
    id: root
    live: false

    required property string iconName

    background: Rectangle {
        anchors.centerIn: parent

        height: 30
        width: root.width + height
        radius: height / 2
        color: Style.color.base.surface1

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            x: 0
            color: Style.color.base.text

            width: height + root.visualPosition * root.width
            height: parent.height
            radius: height / 2
        }
    }

    handle: Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: root.visualPosition * root.width - width / 2 + 1
        color: "transparent"

        width: 30
        height: 30

        MaterialIcon {
            anchors.centerIn: parent
            text: root.iconName
            color: Style.color.base.surface0
            size: Style.font.size.large
        }
    }
}
