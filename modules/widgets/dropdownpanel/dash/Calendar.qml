pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.utils
import qs.config
import qs.services

RowLayout {
    id: root

    Item {
        Layout.fillHeight: true
        implicitWidth: text.implicitHeight + Style.spacing.large

        Rectangle {
            anchors.fill: parent
            color: Style.color.base.mantle
            radius: Style.rounding.small - 3
        }

        StyledText {
            id: text
            anchors.fill: parent
            anchors.topMargin: 50
            color: Style.color.accent.current
            font.pointSize: Style.font.size.normal
            text: Time.format("MMM, yyyy")
            rotation: -90
        }
    }

    ColumnLayout {
        id: columnLayout

        DayOfWeekRow {
            Layout.fillWidth: true
            locale: grid.locale

            delegate: StyledText {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                required property var shortName

                text: shortName
                color: Style.color.accent.current
            }
        }

        MonthGrid {
            id: grid
            Layout.fillWidth: true
            Layout.fillHeight: true

            readonly property int today: parseInt(Time.format("d"))
            locale: Qt.locale("en_US")

            delegate: Rectangle {
                required property var model
                readonly property bool isToday: grid.today === model.day && grid.month === model.month
                readonly property bool isThisMonth: grid.month === model.month

                color: isToday ? Style.color.accent.current : "transparent"
                radius: height / 2

                StyledText {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    text: parent.model.day
                    color: parent.isThisMonth ? (parent.isToday ? Style.color.base.base : Style.color.base.text) : Style.color.base.surface1
                }
            }
        }
    }
}
