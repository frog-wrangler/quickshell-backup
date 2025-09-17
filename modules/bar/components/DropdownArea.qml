import QtQuick
import "root:/services"
import "root:/modules/widgets/dropdownpanel"

Item {
    id: root
    width: 350
    height: 2

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.UpArrowCursor
        hoverEnabled: true

        onEntered: {
            GlobalStates.dropdownOpen = true;
        }
    }

    DropdownPanel {}
}
