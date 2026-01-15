pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import qs.config
import qs.services
import qs.utils

ContentPage {
    id: root
    baseWidth: 550
    forceWidth: true

    ContentSection {
        title: "Background"

        ListView {
            Layout.fillWidth: true
            implicitHeight: 300
            clip: true

            model: FolderListModel {
                id: folderModel
                folder: "file://" + Quickshell.shellDir + "/data/wallpapers/"
            }

            delegate: Item {
                id: fileDelegate
                implicitHeight: 100

                required property var modelData

                StyledText {
                    id: label
                    anchors.top: fileDelegate.top
                    anchors.left: fileDelegate.left

                    text: modelData.fileName
                }

                Image {
                    id: image
                    anchors.top: label.bottom
                    anchors.left: fileDelegate.left
                    height: 70
                    width: 120
                    sourceSize.height: height * 2
                    sourceSize.width: width * 2

                    asynchronous: true
                    source: modelData.filePath

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            Quickshell.execDetached(["qs", "ipc", "call", "background", "setWallpaper", modelData.filePath]);
                        }
                    }
                }
            }
        }

        ToggleItem {
            Layout.fillWidth: true
            text: "Clock on Wallpaper"
            active: Settings.getValue("clockOnWallpaper")

            onClicked: {
                Quickshell.execDetached(["qs", "ipc", "call", "background", "setClockOnWallpaper", !active]);
            }
        }

        ToggleItem {
            Layout.fillWidth: true
            text: "Clock on Lockscreen"
            active: Settings.getValue("clockOnLockscreen")

            onClicked: {
                Quickshell.execDetached(["qs", "ipc", "call", "background", "setClockOnLockscreen", !active]);
            }
        }
    }

    ContentSection {
        title: "Decorations & Effects"

        ToggleItem {
            Layout.fillWidth: true
            text: "Testing"

            onClicked: {
                console.log("Clicked!");
            }
        }
    }

    ContentSection {
        title: "Fake Screen Rounding"
    }
}
