import QtQuick
import qs.config
import qs.utils
import qs.services

Item {
    anchors.margins: DesktopBackground.clockMargins
    implicitWidth: timeText.implicitWidth
    implicitHeight: timeText.implicitHeight
    opacity: DesktopBackground.clockOpacity

    Text {
        id: timeText

        anchors.centerIn: parent
        text: Time.format("hh:mm")
        color: DesktopBackground.clockColor
        font.family: Style.font.family.clock
        font.pointSize: Style.font.size.huge
    }

    StyledText {
        id: dateText
        anchors.left: timeText.left
        anchors.top: timeText.bottom
        text: Time.format("dddd, d/M")
        color: DesktopBackground.clockColor
        font.family: Style.font.family.clock
        font.pointSize: Style.font.size.extraLarge
    }
}
