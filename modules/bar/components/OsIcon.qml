import QtQuick
import "root:/config"
import "root:/utils"

Item {
    id: root
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
