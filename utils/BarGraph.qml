import QtQuick
import Quickshell.Widgets
import qs.config

Item {
    id: root
    implicitHeight: bar.height + infoText.implicitHeight

    required property int barHeight
    required property real value
    property real from: 0.0
    property real to: 1.0
    
    readonly property real range: to - from
    
    property color fillBarColor: Style.color.accent.current
    property color baseBarColor: Style.color.base.surface0
    property real radius: Style.rounding.normal

    property string text: ""

    ClippingRectangle {
        id: bar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: root.barHeight
        
        color: root.baseBarColor
        radius: root.radius
        
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * ((root.value - root.from) / root.range)

            color: root.fillBarColor
        }
    }

    StyledText {
        id: infoText
        anchors.top: bar.bottom
        anchors.horizontalCenter: bar.horizontalCenter
        anchors.margins: 10
        horizontalAlignment: Text.AlignHCenter

        text: root.text
    }
}
