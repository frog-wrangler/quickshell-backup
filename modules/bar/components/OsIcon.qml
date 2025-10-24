import QtQuick
import qs.config
import qs.utils

Item {
    implicitHeight: Style.size.barSize
    implicitWidth: osIcon.width
    
    StyledText {
        id: osIcon
        anchors.centerIn: parent

        color: Style.color.accent.current
        font.family: Style.font.family.mono
        font.pointSize: Style.font.size.large
        text: "󰣇"
    }
}
