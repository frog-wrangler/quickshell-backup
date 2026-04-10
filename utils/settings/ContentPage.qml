import QtQuick
import QtQuick.Layouts
import qs.config

Flickable {
    id: root
    default property alias data: contentColumn.data

    clip: true
    property bool forceWidth: false
    property real baseWidth: 550
    contentHeight: contentColumn.implicitHeight + Style.spacing.small * 2 + Style.size.settingsVerticalMargins
    implicitWidth: contentColumn.implicitWidth

    ColumnLayout {
        id: contentColumn
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10

        width: root.forceWidth ? root.baseWidth : Math.max(root.baseWidth, implicitWidth)

        spacing: 20
    }
}
