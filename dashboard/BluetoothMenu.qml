import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: btMenu
    // Flexible size (no fixed height)

    ListModel { id: btModel }

    Process {
        id: btScan
        command: ["bluetoothctl", "devices"]
        
        onStdoutChanged: {
            btModel.clear()
            var lines = btScan.stdout.split("\n")
            for (var i = 0; i < lines.length; i++) {
                if (!lines[i]) continue
                var parts = lines[i].split(" ")
                
                if (parts[0] === "Device" && parts.length >= 3) {
                    btModel.append({
                        "mac": parts[1],
                        "name": parts.slice(2).join(" ")
                    })
                }
            }
        }
    }

    Timer {
        interval: 8000; running: true; repeat: true
        triggeredOnStart: true
        onTriggered: btScan.running = true
    }

    ListView {
        anchors.fill: parent
        model: btModel
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
                    text: ""
                    color: "#b4befe"
                }

                Text {
                    text: name
                    color: "#cdd6f4"
                    width: 180
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                width: 60; height: 24
                color: "#45475a"
                radius: 4
                
                Text {
                    anchors.centerIn: parent
                    text: "Pair"
                    color: "white"
                    font.pixelSize: 10
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log("Pairing " + mac)
                }
            }
        }
    }
}
