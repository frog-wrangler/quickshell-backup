pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root
    readonly property bool isCelsius: false

    property string loc
    property string icon
    property string description 

    // Current, High, Low ==> bad pwactice uwu
    property var temp: [ "0°F", "0°F", "0°F" ]
    property var tempTomorrow: [ "0°F", "0°F" ]
    property int rawLowF: 50
    property int rawHighF: 50
    property int rawLowTomorrowF: 50
    property int rawHighTomorrowF: 50

    property string precipPercent: "0%"
    property string humidity: "0%"
    property string dewPoint: "0°F"

    property int uvIndex: 0
    property string cloudCover: "0%"

    // Rise, Set
    property var sunTimes: [ "0:00", "0:00" ]
    property var moonTimes: [ "0:00", "0:00" ]
    property string moonPhase: ""
    
    property int visibilityMiles: 100

    function convert(temp: int): string {
        if (!isCelsius) return `${temp}°F`;

        return `${(temp - 32) / 1.8}°C`;
    }

    function reload() {
        if (!loc || timer.elapsed() > 900) {
            Requests.get("https://ipinfo.io/json", text => {
                loc = JSON.parse(text).loc ?? "";
                timer.restart();
            });
        }
    }

    onLocChanged: Requests.get(`https://wttr.in/${loc}?format=j1`, text => {
        const json = JSON.parse(text);
        const current = json.current_condition[0];
        const today = json.weather[0];
        const tomorrow = json.weather[1];

        icon = Icons.getWeatherIcon(current.weatherCode);
        description = current.weatherDesc[0].value;

        temp[0] = convert(parseInt(current.temp_F));
        temp[1] = convert(parseInt(today.maxtempF));
        temp[2] = convert(parseInt(today.mintempF));
        tempTomorrow[0] = convert(parseInt(tomorrow.maxtempF));
        tempTomorrow[1] = convert(parseInt(tomorrow.mintempF));

        rawLowF = parseInt(today.mintempF);
        rawHighF = parseInt(today.maxtempF);
        rawLowTomorrowF = parseInt(tomorrow.mintempF);
        rawHighTomorrowF = parseInt(tomorrow.maxtempF);

        precipPercent = today.hourly[0].chanceofrain + "%";
        humidity = current.humidity + "%";
        dewPoint = convert(parseInt(today.hourly[0].dewPointF));

        uvIndex = parseInt(today.uvIndex);
        cloudCover = current.cloudCover + "%";

        sunTimes[0] = today.astronomy[0].sunrise;
        sunTimes[1] = today.astronomy[0].sunset;
        moonTimes[0] = today.astronomy[0].moonrise;
        moonTimes[1] = today.astronomy[0].moonset;
        moonPhase = today.astronomy[0].moon_phase;

        visibilityMiles = parseInt(current.visibilityMiles);
    })

    Component.onCompleted: reload();

    ElapsedTimer {
        id: timer
    }
}
