import QtQuick
import QtQuick.Controls
import qs.config
import qs.services
import qs.utils

Rectangle {
    id: root
    height: 100
    radius: Style.rounding.small
    color: Style.color.base.surface0

    ComboBox {
        id: selector
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Style.spacing.large
        implicitHeight: 25

        model: Audio.sinks

        Component.onCompleted: {
            selector.currentIndex = Audio.sinks.indexOf(Audio.sink);
            console.log(Audio.sinks.indexOf(Audio.sink));
        }

        onCurrentIndexChanged: {
            const sink = selector.model[selector.currentIndex];
            if (sink != Audio.sink) {
                Audio.setDefaultSink(sink);
            }
        }

        delegate: ItemDelegate {
            id: delegate
            required property var modelData
            required property int index

            width: selector.width
            background: Rectangle {
                anchors.fill: parent
                color: delegate.highlighted ? Style.color.base.surface0 : Style.color.base.surface1
            }
            contentItem: StyledText {
                text: modelData.description
                elide: Text.ElideRight
            }
            highlighted: selector.highlightedIndex === index
        }

        contentItem: StyledText {
            text: selector.model[selector.currentIndex]?.description || "N/a"
            leftPadding: 10
            elide: Text.ElideRight
        }

        background: Rectangle {
            radius: height / 2
            color: Style.color.base.surface1
        }

        popup.background: Rectangle {
            color: Style.color.base.surface1
        }
    }

    StyledSlider {
        id: audioSlider
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 30
        anchors.rightMargin: 30
        implicitHeight: 60

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
