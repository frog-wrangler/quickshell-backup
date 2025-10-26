import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.config
import qs.utils
import qs.services
import qs.modules.widgets.dropdownpanel.dash

GridLayout {
    id: root

    rowSpacing: 6
    columnSpacing: 6
    uniformCellHeights: true
    uniformCellWidths: true

    rows: 4
    columns: 3

    Rect {
        id: audio
        Layout.row: 0
        Layout.column: 0
        Layout.columnSpan: 2

        StyledSlider {
            id: audioSlider
            anchors.fill: parent
            anchors.leftMargin: 30
            anchors.rightMargin: 30
            snapMode: Slider.SnapAlways
            stepSize: 0.05

            iconName: {
                if (Audio.muted)
                    return "no_sound";

                if (visualPosition == 0)
                    return "no_sound";
                if (visualPosition < 0.5)
                    return "volume_down_alt";
                return "volume_up";
            }

            onPressedChanged: {
                if (!pressed)
                    Audio.setVolume(value);
            }

            Connections {
                target: Audio
                function onChanged(newVolume) {
                    audioSlider.value = Audio.volume;
                }
            }

            Component.onCompleted: {
                value = Audio.volume;
            }
        }
    }

    Rect {
        id: brightness
        Layout.row: 1
        Layout.column: 0
        Layout.columnSpan: 2

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

    Rect {
        id: info
        Layout.row: 0
        Layout.column: 2
        Layout.rowSpan: 2

        Image {
            anchors.fill: parent
            source: "root:/data/sillyguy.png"
            fillMode: Image.PreserveAspectFit
            asynchronous: true
        }
    }

    Item {
        id: weather
        Layout.row: 2
        Layout.column: 0
        Layout.fillHeight: true
        Layout.fillWidth: true

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            implicitHeight: parent.height * 4 + root.rowSpacing * 3
            radius: 7
            color: Style.color.base.surface0

            Weather {
                anchors.fill: parent
                anchors.margins: 10
            }
        }
    }

    Item {
        Layout.row: 3
        Layout.column: 0
    }

    Item {
        Layout.row: 4
        Layout.column: 0
    }

    Item {
        Layout.row: 5
        Layout.column: 0
    }

    Rect {
        Layout.row: 2
        Layout.column: 1
        Layout.columnSpan: 2
        Layout.rowSpan: 4

        Calendar {
            id: calendar
            anchors.fill: parent
            anchors.margins: 10
        }
    }

    component Rect: Rectangle {
        radius: 7
        color: Style.color.base.surface0
        Layout.fillHeight: true
        Layout.fillWidth: true
    }
}
