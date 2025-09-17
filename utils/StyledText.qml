import QtQuick
import "root:/config"

Text {
    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter
    font {
        hintingPreference: Font.PreferFullHinting
        family: Style.font.family.mono
        pointSize: Style.font.size.small
    }
    color: Style.color.base.text
    linkColor: Style.color.accent.current
}
