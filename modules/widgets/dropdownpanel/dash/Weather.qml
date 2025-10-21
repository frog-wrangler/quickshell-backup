import QtQuick
import QtQuick.Layouts
import qs.utils
import qs.config
import qs.services

ColumnLayout {
    id: root
    spacing: 10

    RowLayout {
        id: topRow
        Layout.fillWidth: true
        Layout.fillHeight: true

        Column {
            Layout.fillWidth: true
            spacing: 10

            MaterialIcon {
                anchors.horizontalCenter: parent.horizontalCenter

                text: WeatherService.icon
                color: Style.color.accent.current
                size: Style.font.size.extraLarge * 2
            }

            StyledText {
                text: WeatherService.temp[0]
                color: Style.color.accent.current
                font.pointSize: Style.font.size.normal
                anchors.horizontalCenter: parent.horizontalCenter
            }

            StyledText {
                text: WeatherService.temp[1] + " / " + WeatherService.temp[2]
                font.pointSize: Style.font.size.small
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        StyledText {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: {
                const precip = WeatherService.precipPercent + " rain";
                const humidity = WeatherService.humidity + " humidity";
                const uv = WeatherService.uvIndex + " uv index";

                return precip + "\n" + humidity + "\n" + uv;
            }
        }
    }

    Rectangle {
        id: separator
        Layout.fillWidth: true
        implicitHeight: 2

        color: Style.color.base.surface1
    }

    RowLayout {
        id: bottomRow
        Layout.fillWidth: true

        Column {
            Layout.fillWidth: true

            MaterialIcon {
                anchors.horizontalCenter: parent.horizontalCenter

                text: "sunny"
                color: Style.color.base.text
                size: Style.font.size.extraLarge
            }

            StyledText {
                id: sunTimes
                anchors.horizontalCenter: parent.horizontalCenter
                text: WeatherService.sunTimes[0] + "\n" + WeatherService.sunTimes[1]
            }
        }

        Column {
            Layout.fillWidth: true

            MaterialIcon {
                anchors.horizontalCenter: parent.horizontalCenter

                text: "bedtime"
                color: Style.color.base.text
                size: Style.font.size.extraLarge
            }

            StyledText {
                id: moonTimes
                anchors.horizontalCenter: parent.horizontalCenter
                text: WeatherService.moonTimes[0] + "\n" + WeatherService.moonTimes[1]
            }
        }
    }
       
    StyledText {
        visible: text != ""
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter

        color: Style.color.accent.orange
        text: {
            if (WeatherService.rawHighF > 89)
                return WeatherService.temp[1] + " HIGH TODAY";
            if (WeatherService.rawLowF < 33)
                return WeatherService.temp[2] + " LOW TODAY";

            if (WeatherService.rawHighTomorrowF > 89)
                return WeatherService.tempTomorrow[1] + " HIGH TOMORROW";
            if (WeatherService.rawLowTomorrowF < 33)
                return WeatherService.tempTomorrow[2] + " LOW TOMORROW";

            if (WeatherService.uvIndex > 4)
                return "UV INDEX: " + WeatherService.uvIndex;
            
            if (WeatherService.visibilityMiles < 3)
                return "VISIBILITY: " + WeatherService.visibilityMiles + " MILES";

            return "";
        }
    }
}
