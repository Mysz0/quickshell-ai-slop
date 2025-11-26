import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: wifiMenu
    // REMOVED fixed height/width to let Layout handle it
    
    ListModel { id: netModel }

    Process {
        id: wifiScan
        command: ["nmcli", "-t", "-f", "IN-USE,SSID,SIGNAL", "dev", "wifi"]
        
        onStdoutChanged: {
            netModel.clear()
            var lines = wifiScan.stdout.split("\n")
            for (var i = 0; i < lines.length; i++) {
                if (!lines[i]) continue
                var parts = lines[i].split(":")
                
                // Ensure we have SSID and it's not empty
                if (parts.length >= 2 && parts[1].length > 0) {
                    netModel.append({
                        "active": parts[0] === "*",
                        "ssid": parts[1],
                        "signal": parts[2] || "?"
                    })
                }
            }
        }
    }

    Timer {
        interval: 5000; running: true; repeat: true
        triggeredOnStart: true
        onTriggered: wifiScan.running = true
    }

    ListView {
        anchors.fill: parent
        model: netModel
        clip: true
        spacing: 4

        delegate: Rectangle {
            width: ListView.view.width
            height: 36
            color: hoverHandler.hovered ? "#313244" : "transparent"
            radius: 6

            HoverHandler { id: hoverHandler }

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                Text {
                    text: active ? "" : "" 
                    color: active ? "#a6e3a1" : "#cdd6f4"
                    font.family: "JetBrainsMono Nerd Font" // Ensure you have a Nerd Font
                }

                Text {
                    text: ssid
                    color: active ? "#a6e3a1" : "#cdd6f4"
                    font.bold: active
                }
            }
            
            // Signal Strength
            Text {
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: signal + "%"
                color: "#6c7086"
                font.pixelSize: 10
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Placeholder for connection logic
                    console.log("Connect to " + ssid)
                }
            }
        }
    }
}
