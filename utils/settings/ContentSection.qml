import QtQuick
import QtQuick.Layouts
import qs.config
import qs.utils

Item {
    id: root
    property string title
    default property alias data: sectionContent.data

    Layout.fillWidth: true
    height: layout.implicitHeight

    Rectangle {
        id: background
        anchors.fill: parent
        anchors.margins: -Style.spacing.small
        anchors.leftMargin: -Style.spacing.large
        anchors.rightMargin: -Style.spacing.large

        color: Style.color.base.surface0
        radius: Style.rounding.normal
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 8

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: root.title ?? ""
            font.pointSize: Style.font.size.normal
            font.weight: Font.Medium
        }

        ColumnLayout {
            id: sectionContent
            Layout.fillWidth: true
            spacing: 8
        }
    }
}
