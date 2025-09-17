import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    default property alias data: rowLayout.data
    property real spacing: 5
    property real padding: 0

    property real contentWidth: {
        let total = 0;
        for (let i = 0; i < rowLayout.children.length; i++) {
            const child = rowLayout.children[i];
            if (!child.visible) continue;
            total += child.implicitWidth ?? child.width;
        }
        return total + rowLayout.spacing * (rowLayout.children.length - 1);
    }

    color: "transparent"
    width: contentWidth + padding * 2
    implicitWidth: contentWidth + padding * 2
    implicitHeight: rowLayout.implicitHeight

    children: [RowLayout {
        id: rowLayout
        anchors.fill: parent
        anchors.margins: root.padding
        spacing: root.spacing
    }]
}
