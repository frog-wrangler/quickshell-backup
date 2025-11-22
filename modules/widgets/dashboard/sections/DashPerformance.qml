import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.config
import qs.services
import qs.utils

Rectangle {
    id: root
    height: 165
    radius: Style.rounding.small
    color: "transparent"

    RowLayout {
        id: rowLayout
        anchors.fill: parent
        anchors.leftMargin: Style.spacing.small
        anchors.rightMargin: Style.spacing.small

        Resource {
            Layout.fillHeight: true
            Layout.fillWidth: true

            percent: SystemUsage.cpuPercent
            text: `CPU: ${Math.round(SystemUsage.cpuPercent * 100)}%\n${SystemUsage.cpuTemp}°C`
        }

        Resource {
            Layout.fillHeight: true
            Layout.fillWidth: true

            percent: SystemUsage.gpuPercent
            text: `GPU: ${Math.round(SystemUsage.gpuPercent * 100)}%\n${SystemUsage.gpuTemp}°C`
        }

        Resource {
            Layout.fillHeight: true
            Layout.fillWidth: true

            readonly property var usedKib: SystemUsage.formatKib(SystemUsage.memUsed)
            readonly property var totalKib: SystemUsage.formatKib(SystemUsage.memTotal)

            percent: SystemUsage.memPercent
            text: `RAM: ${Math.round(SystemUsage.memPercent * 100)}%\
                    \n${Math.round(usedKib.value * 10) / 10} ${totalKib.unit}`
        }
    }

    component Resource: Item {
        id: res

        required property string text
        required property real percent

        Dial {
            id: dial
            anchors.fill: parent

            enabled: false

            background: Rectangle {
                id: dialBackground
                anchors.centerIn: parent
                width: dial.width - Style.spacing.small
                height: width

                color: Style.color.base.base
                radius: width

                Canvas {
                    id: canvas
                    anchors.fill: parent

                    Connections {
                        target: dial
                        function onValueChanged() {
                            canvas.requestPaint();
                        }
                    }

                    onPaint: {
                        var ctx = canvas.getContext("2d");
                        ctx.reset();
                        var startAngle = Math.PI * 3 / 4;
                        var endAngle = startAngle + dial.value * Math.PI * 3 / 2;
                        ctx.lineWidth = 6;
                        ctx.lineCap = "round";

                        ctx.strokeStyle = Style.color.base.surface0;
                        ctx.beginPath();
                        ctx.arc(width / 2, height / 2, 53, startAngle, Math.PI / 4);
                        ctx.stroke();

                        ctx.strokeStyle = Style.color.base.text;
                        ctx.beginPath();
                        ctx.arc(width / 2, height / 2, 53, startAngle, endAngle);
                        ctx.stroke();
                    }
                }
            }

            handle: null

            value: res.percent
        }

        StyledText {
            anchors.centerIn: dial
            horizontalAlignment: Text.AlignHCenter

            text: res.text
        }
    }

    Component.onCompleted: {
        SystemUsage.inUse = true;
    }

    Component.onDestruction: {
        SystemUsage.inUse = false;
    }
}
