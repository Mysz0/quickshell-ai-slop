import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: wifiMenu
    // Let ControlCenter handle layout
    
    property bool isEthernet: false

    ListModel { id: netModel }

    // Existing Wifi Scan
    Process {
        id: wifiScan
        command: ["nmcli", "-t", "-f", "IN-USE,SSID,SIGNAL,SECURITY", "dev", "wifi"]
        
        onStdoutChanged: {
            netModel.clear()
            var lines = wifiScan.stdout.split("\n")
            for (var i = 0; i < lines.length; i++) {
                if (!lines[i]) continue
                var parts = lines[i].split(":") 
                
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

    // New: Check for Ethernet
    Process {
        id: ethCheck
        command: ["nmcli", "-t", "-f", "TYPE,STATE", "device"]
        onStdoutChanged: {
            // Looks for a line like "ethernet:connected"
            isEthernet = stdout.indexOf("ethernet:connected") !== -1
        }
    }

    Timer {
        interval: 5000; running: true; repeat: true
        triggeredOnStart: true
        onTriggered: {
            wifiScan.running = true
            ethCheck.running = true
        }
    }

    // Network List
    ListView {
        anchors.fill: parent
        model: netModel
        clip: true
        spacing: 4
        visible: netModel.count > 0 // Hide if empty

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

    // New: Ethernet / Empty State
    Column {
        anchors.centerIn: parent
        visible: netModel.count === 0
        spacing: 10
        
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            // Ethernet icon or Disconnected Wifi icon
            text: isEthernet ? "󰈀" : "󰤭" 
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 48
            color: "#585b70"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: isEthernet ? "Wired Connection" : "No Networks Found"
            color: "#cdd6f4"
            font.bold: true
            font.pixelSize: 14
        }
        
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: isEthernet ? "Connected via Ethernet" : "Check your settings"
            color: "#6c7086"
            font.pixelSize: 12
            visible: isEthernet
        }
    }
}
