import QtQuick
import qs.config
import qs.services
import qs.utils

Rectangle {
    id: root
    height: 60
    radius: Style.rounding.small
    color: Style.color.base.surface0

    StyledSlider {
        id: brightnessSlider
        anchors.fill: parent
        anchors.leftMargin: 30
        anchors.rightMargin: 30

        iconName: {
            if (visualPosition == 0)
                return "brightness_1";
            if (visualPosition < 0.2)
                return "brightness_2";
            if (visualPosition < 0.4)
                return "brightness_3";
            if (visualPosition < 0.6)
                return "brightness_4";
            if (visualPosition < 0.8)
                return "brightness_5";
            if (visualPosition < 1)
                return "brightness_6";
            return "brightness_7";
        }

        onPressedChanged: {
            if (!pressed)
                Brightness.setBrightness(value);
        }

        Connections {
            target: Brightness
            function onChanged(newBrightness) {
                brightnessSlider.value = Brightness.brightness;
            }
        }

        Component.onCompleted: {
            Brightness.update();
            value = Brightness.brightness;
        }
    }
}
