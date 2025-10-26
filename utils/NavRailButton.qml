import QtQuick
import QtQuick.Controls
import qs.config

TabButton {
    id: root

    required property bool toggled
    required property bool expanded
    required property string iconName
    required property string buttonText

    padding: 0

    implicitWidth: expanded ? itemText.implicitWidth + 70 : 50
    implicitHeight: 50

    background: Rectangle {
        id: background
        anchors.fill: parent

        color: root.toggled ? Style.color.accent.current : (mouseArea.containsMouse ? Style.color.base.surface0 : Style.color.base.base)
        radius: Style.rounding.normal
    }

    contentItem: Item {
        id: buttonContent
        anchors.fill: parent

        MaterialIcon {
            id: icon
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            text: root.iconName
            color: root.toggled ? Style.color.base.base : Style.color.base.text
            size: Style.font.size.large

            width: 50
            height: 50
        }

        StyledText {
            id: itemText
            visible: root.expanded
            anchors.left: icon.right
            anchors.verticalCenter: parent.verticalCenter

            text: root.buttonText
            color: icon.color
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            root.clicked();
        }
    }
}
