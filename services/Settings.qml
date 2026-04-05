pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property list<Setting> settingsList: []
    signal loaded

    component Setting: QtObject {
        property string id
        property var value
    }

    function set(id: string, value: var): void {
        let s = find(id);
        if (s) {
            s.value = value;
        } else {
            s = settingComp.createObject(root, {
                "id": id,
                "value": value
            });
            settingsList.push(s);
        }
        jsonFile.setText(JSON.stringify(settingsList, null, "\t"));
    }

    function getValue(id) {
        for (const setting of settingsList) {
            if (setting.id === id) return setting.value;
        }
        return null;
    }

    function find(id: string): Setting {
        for (const setting of settingsList) {
            if (setting.id === id) return setting;
        }
        return null;
    }

    property Component settingComp: Setting {}

    Component.onCompleted: {
        jsonFile.reload();
    }

    FileView {
        id: jsonFile
        path: ".config/quickshell/data/settings.json"

        onLoaded: {
            root.settingsList = JSON.parse(text()).map(setting => {
                return root.settingComp.createObject(root, {
                    "id": setting.id,
                    "value": setting.value
                });
            });
            root.loaded();
        }

        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                console.warn("Settings file not found, creating new file.");
                root.settingsList = [];
                jsonFile.setText(root.stringifyList(root.settingsList));
            } else {
                console.error("Error loading settings file: " + error);
            }
        }
    }
}
