pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    // property bool ready: Pipewire.ready
    property var sinks: Pipewire.nodes.values.filter((node) => node.isSink)

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0

    function setVolume(volume: real): void {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = false;
            sink.audio.volume = volume;
        }
    }

    signal changed(newVolume: real)
    onVolumeChanged: {
        changed(volume);
    }

    // onReadyChanged: {
    //     console.log("Ready: " + ready);
    // }
    // onSinkChanged: {
    //     console.log("Sink changed to: " + (sink.description || sink.name));
    // }

    function setDefaultSink(pNode) {
        Pipewire.preferredDefaultAudioSink = pNode;
    }

    function updateSinks(): void {
        root.sinks = Pipewire.nodes.values.filter((node) => node.isSink);
    }

    Connections {
        target: Pipewire.nodes
        function onObjectInsertedPost() {
            root.updateSinks();
        }
        function onObjectRemovedPost() {
            root.updateSinks();
        }
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }
}
