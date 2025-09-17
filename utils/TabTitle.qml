import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:/config"
import "root:/utils"

TabButton {
    id: root

    required property string title
    required property string iconName
    required property bool active

    contentItem: Item {
        anchors.fill: parent
        implicitHeight: content.implicitHeight

        ColumnLayout {
            id: content
            anchors.fill: parent

            MaterialIcon {
                Layout.alignment: Qt.AlignHCenter
                height: 20

                text: root.iconName
                color: root.active ? Style.color.accent.current : Style.color.base.subtext
                size: Style.font.size.large
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter

                color: root.active ? Style.color.accent.current : Style.color.base.subtext
                text: root.title
            }
        }
    }

    background: MouseArea {
        anchors.centerIn: parent
        height: parent.height + 20
        width: parent.width

        cursorShape: Qt.PointingHandCursor
    }
}
