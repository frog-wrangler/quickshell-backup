import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services
import qs.utils

Item {
    id: root
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Style.size.barSize

    property bool showSong: Players.active
    property string activeWindow: Hyprland.activeToplevel?.title ?? "Desktop"
    property string activeAudio: Players.active?.trackTitle || "Unknown Title"

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: Style.spacing.normal

        MaterialIcon {
            visible: showSong
            size: Style.font.size.large
            color: Style.color.base.text
            text: "music_note"
        }

        StyledText {
            visible: showSong
            font.pointSize: Style.font.size.normal
            text: activeAudio.length > 25 ? activeAudio.slice(0, 25).trim() + "..." : activeAudio
        }

        StyledText {
            visible: root.showSong
            font.pointSize: Style.font.size.large
            text: "•"
        }

        MaterialIcon {
            size: Style.font.size.large
            color: Style.color.base.text
            text: Icons.getAppCategoryIcon(Hyprland.activeToplevel?.lastIpcObject?.class, "computer")
        }

        StyledText {
            font.pointSize: Style.font.size.normal
            text: activeWindow.length > 25 ? activeWindow.slice(0, 25).trim() + "..." : activeWindow
        }
    }
}
