import QtQuick
import QtQuick.Layouts
import qs.services
import qs.config
import qs.utils

Item {
    id: root
    property bool showDate: true
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Style.size.barSize

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 6

        StyledText {
            font.pointSize: Style.font.size.normal
            text: Time.format("hh:mm ap")
        }

        StyledText {
            visible: root.showDate
            font.pointSize: Style.font.size.large
            text: "•"
        }

        StyledText {
            visible: root.showDate
            font.pointSize: Style.font.size.normal
            text: Time.format("ddd, MM/dd")
        }
    }
}
