import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: wifiMenu
    // No fixed height! Let ControlCenter handle it.

    ListModel { id: netModel }

    Process {
        id: wifiScan
        command: ["nmcli", "-t", "-f", "IN-USE,SSID,SIGNAL,SECURITY", "dev", "wifi"]
        
        onStdoutChanged: {
            netModel.clear()
            var lines = wifiScan.stdout.split("\n")
            for (var i = 0; i < lines.length; i++) {
                if (!lines[i]) continue
                var parts = lines[i].split(":") // nmcli -t uses : as separator
                
                if (parts[1] && parts[1].length > 0) {
                    netModel.append({
                        "active": parts[0] === "*",
                        "ssid": parts[1],
                        "signal": parts[2] || "?",
                        "security": parts[3] || ""
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
            color: active ? "#313244" : (hoverHandler.hovered ? "#45475a" : "transparent")
            radius: 6

            HoverHandler { id: hoverHandler }

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                Text {
                    text: active ? "" : "" 
                    color: active ? "#a6e3a1" : "#cdd6f4"
                    font.family: "JetBrainsMono Nerd Font" 
                }

                Text {
                    text: ssid
                    color: active ? "#a6e3a1" : "#cdd6f4"
                    font.bold: active
                }
            }
            
            Text {
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: signal + "%"
                color: "#6c7086"
                font.pixelSize: 10
            }
        }
    }
}
