pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property list<MprisPlayer> list: Mpris.players.values
    readonly property MprisPlayer active: list.find(p => p.identity === "YouTube Music") ?? list[0] ?? null

    function getActive(prop: string): string {
        return active ? (active[prop] ?? "Invalid property") : "No active player";
    }

    function play(): void {
        if (active?.canPlay)
            active.play();
    }

    function pause(): void {
        if (active?.canPause)
            active.pause();
    }

    function togglePlay(): void {
        if (active?.canTogglePlaying)
            active.togglePlaying();
    }

    function previous(): void {
        if (active?.canGoPrevious)
            active.previous();
    }

    function next(): void {
        if (active?.canGoNext)
            active.next();
    }

    function stop(): void {
        active?.stop();
    }
}
