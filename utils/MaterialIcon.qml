import QtQuick
import qs.config

Item {
    id: root
    required property string text
    required property color color
    required property int size

    width: icon.implicitWidth
    height: Style.size.barSize

    StyledText {
        id: icon
        anchors.centerIn: parent
        color: root.color

        property real fill
        property int grade: -25

        text: root.text
        font.family: Style.font.family.icons
        font.pointSize: root.size
        font.variableAxes: ({
            FILL: fill.toFixed(1),
            GRAD: grade,
            opsz: fontInfo.pixelSize,
            wght: fontInfo.weight
        })
    }
}
