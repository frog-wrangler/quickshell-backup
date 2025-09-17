import QtQuick
import QtQuick.Layouts
import qs.config

ColumnLayout {
    id: root
    property string title
    default property alias data: sectionContent.data

    Layout.fillWidth: true
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
