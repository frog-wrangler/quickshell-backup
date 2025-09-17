import QtQuick
import "root:/utils"
import "root:/config"
import "root:/services"

Item {
    id: root

    readonly property bool isActive: ListView.isCurrentItem

    readonly property int barHeights: 300
    readonly property int barWidths: 120
    readonly property int barMargins: 30

    Rectangle {
        id: statBackground
        anchors.left: ramPercent.right
        anchors.top: ramPercent.top
        anchors.leftMargin: 30

        implicitHeight: root.barHeights//statText.implicitHeight + 20
        implicitWidth: statText.implicitWidth + 20

        color: Style.color.base.mantle
        radius: Style.rounding.small
    }

    StyledText {
        id: statText
        anchors.horizontalCenter: statBackground.horizontalCenter
        anchors.top: statBackground.top
        anchors.topMargin: 10

        readonly property var storUsed: SystemUsage.formatKib(SystemUsage.storageUsed)
        readonly property var storTotal: SystemUsage.formatKib(SystemUsage.storageTotal)

        text: "Stats: " + "\n" + 
            "\nFan speed: " + SystemUsage.fanSpeed + "\n" +
            "\nStorage used: " + (Math.round(storUsed.value * 10) / 10) + " " + storUsed.unit +
            "\nStorage total: " + (Math.round(storTotal.value * 10) / 10) + " " + storTotal.unit +
            "\nStorage percent: " + SystemUsage.storagePercent
    }

    BarGraph {
        id: cpuPercent
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: root.barMargins

        implicitWidth: root.barWidths
        barHeight: root.barHeights

        value: SystemUsage.cpuPercent
        text: `CPU: ${Math.round(SystemUsage.cpuPercent * 100)}%\n${SystemUsage.cpuTemp}°C`
    }

    BarGraph {
        id: gpuPercent
        anchors.left: cpuPercent.right
        anchors.top: parent.top
        anchors.margins: root.barMargins

        implicitWidth: root.barWidths
        barHeight: root.barHeights

        value: SystemUsage.gpuPercent
        text: `GPU: ${Math.round(SystemUsage.gpuPercent * 100)}%\n${SystemUsage.gpuTemp}°C`
    }

    BarGraph {
        id: ramPercent
        anchors.left: gpuPercent.right
        anchors.top: parent.top
        anchors.margins: root.barMargins

        implicitWidth: root.barWidths
        barHeight: root.barHeights

        readonly property var usedKib: SystemUsage.formatKib(SystemUsage.memUsed)
        readonly property var totalKib: SystemUsage.formatKib(SystemUsage.memTotal)

        value: SystemUsage.memPercent
        text: `RAM: ${Math.round(SystemUsage.memPercent * 100)}%\
        \n${Math.round(usedKib.value * 10) / 10} / ${Math.round(totalKib.value * 10) / 10} ${totalKib.unit}`
    }

    onIsActiveChanged: {
        if (isActive) {
            SystemUsage.inUse = true;
        } else {
            SystemUsage.inUse = false;
        }
    }

    Component.onDestruction: SystemUsage.inUse = false;
}
