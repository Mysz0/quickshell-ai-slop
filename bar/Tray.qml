import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "../theme"
import "../components"

Rectangle {
    // ALIGNMENT FIX:
    // 1. Adapts width to icons
    // 2. Sets height to 24 to fit inside the bar's row
    // 3. Transparent background so it looks seamless
    width: row.implicitWidth + (row.children.length > 0 ? 12 : 0)
    height: 24 
    radius: 12
    color: "transparent"
    visible: row.children.length > 0

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 5

        Repeater {
            model: SystemTray.items

            delegate: Item {
                width: 24
                height: 24
                
                Image {
                    anchors.centerIn: parent
                    width: 18
                    height: 18
                    fillMode: Image.PreserveAspectFit
                    
                    // SPOTIFY ICON FIX:
                    // 1. Check if the incoming icon string contains "spotify"
                    // 2. If yes, ask Quickshell for the real system icon path
                    // 3. If no, use the provided icon string as-is
                    source: {
                        if (modelData.icon.indexOf("spotify") !== -1) {
                            return Quickshell.iconPath("spotify")
                        }
                        return modelData.icon
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: (mouse) => {
                        if (mouse.button === Qt.LeftButton) {
                            modelData.activate()
                        } else if (mouse.button === Qt.RightButton) {
                            modelData.menu?.open(mouse)
                        }
                    }
                }
            }
        }
    }
}
