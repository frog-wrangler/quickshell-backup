import QtQuick
import QtQuick.Layouts
import "root:/utils"

ContentPage {
    id: root
    baseWidth: 550
    forceWidth: true

    ContentSection {
        title: "Colors & Wallpaper"
    }

    ContentSection {
        title: "Decorations & Effects"

        ToggleItem {
            Layout.fillWidth: true

            onClicked: {
                console.log("Clicked!");
            }
        }
    }

    ContentSection {
        title: "Fake Screen Rounding"
    }
}
