import QtQuick
import qs.config
import qs.services

Item {
    anchors.margins: DesktopBackground.clockMargins
    implicitWidth: timeText.implicitWidth
    implicitHeight: timeText.implicitHeight

    Text {
        id: timeText

        anchors.centerIn: parent
        text: Time.format("hh:mm AP")
        color: DesktopBackground.clockColor
        font.family: Style.font.family.sans
        font.pointSize: Style.font.size.huge
    }
}
