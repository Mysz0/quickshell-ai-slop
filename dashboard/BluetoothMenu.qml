import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: btMenu
    
    // Data Model
    ListModel { id: btModel }

    // 1. Process to get devices
    Process {
        id: btScan
        // 'devices' lists all known devices. 
        // Note: Real-time scanning needs 'scan on' running in background system-wide.
        command: ["bluetoothctl", "devices"]
        
        onStdoutChanged: {
            btModel.clear()
            var lines = btScan.stdout.split("\n")
            
            for (var i = 0; i < lines.length; i++) {
                if (lines[i] === "") continue
                
                // Format: "Device XX:XX:XX:XX:XX:XX Name of Device"
                var parts = lines[i].split(" ")
                
                // Ensure it's a valid line starting with "Device"
                if (parts[0] === "Device" && parts.length >= 3) {
                    var mac = parts[1]
                    // Join the rest of the array to get the full name
                    var name = parts.slice(2).join(" ")
                    
                    btModel.append({
                        "mac": mac,
                        "name": name
                    })
                }
            }
        }
    }

    // Refresh every 10 seconds
    Timer {
        interval: 10000; running: true; repeat: true
        triggeredOnStart: true
        onTriggered: btScan.running = true
    }

    // 2. The List View
    ListView {
        anchors.fill: parent
        model: btModel
        clip: true
        spacing: 4

        delegate: Rectangle {
            width: ListView.view.width
            height: 36
            color: "#313244" // Card background
            radius: 6

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                
                Text {
                    text: name
                    color: "white"
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
                
                Text {
                    text: "Connect"
                    color: "#89b4fa"
                    font.pixelSize: 11
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Connecting to " + mac)
                            // You could add a Process here to run: bluetoothctl connect <mac>
                        }
                    }
                }
            }
        }
    }
}
