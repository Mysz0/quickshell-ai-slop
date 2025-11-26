import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: wifiMenu
    width: 300; height: 300

    ListModel { id: netModel }

    Process {
        id: wifiScan
        command: ["nmcli", "-t", "-f", "IN-USE,SSID", "dev", "wifi"]
        
       
        onStdoutChanged: {
            netModel.clear()
            // Access wifiScan.stdout directly
            var lines = wifiScan.stdout.split("\n")
            for (var i = 0; i < lines.length; i++) {
                if (lines[i] === "") continue
                var parts = lines[i].split(":")
                
                if (parts[1] && parts[1] !== "") {
                    netModel.append({
                        "active": parts[0] === "*",
                        "ssid": parts[1]
                    })
                }
            }
        }
    }

    Timer {
        interval: 10000; running: true; repeat: true
        triggeredOnStart: true
        onTriggered: wifiScan.running = true
    }

    ListView {
        anchors.fill: parent
        model: netModel
        delegate: Rectangle {
            width: parent.width; height: 30
            color: "transparent"
            Text {
                anchors.centerIn: parent
                text: ssid
                color: active ? "#a6e3a1" : "#cdd6f4"
            }
        }
    }
}
