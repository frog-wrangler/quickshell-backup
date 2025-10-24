import QtQuick
import qs.services
import qs.modules.widgets.dropdownpanel

Item {
    id: root
    width: 350
    height: 2

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            GlobalStates.dropdownOpen = true;
        }
    }

    DropdownPanel {}
}
