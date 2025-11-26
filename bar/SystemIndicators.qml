import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"

Row {
    spacing: 8
    
    // --- 1. Volume Indicator ---
    property int volumeVal: 0
    property bool isMuted: false
    property string volIcon: ""

    Process {
        id: volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        
        // FIX: Use StdioCollector to actually capture the output
        stdout: StdioCollector {
            onTextChanged: {
                var output = text.trim()
                // Console log to debug if it stays 0%
                // console.log("Vol Output: " + output)
                
                // 1. Check Muted
                isMuted = output.includes("MUTED")

                // 2. Parse Volume (Matches 0.45 or .45)
                var match = output.match(/Volume:\s+([\d\.]+)/)
                if (match && match.length >= 2) {
                    volumeVal = Math.round(parseFloat(match[1]) * 100)
                }
                
                // 3. Update Icon
                if (isMuted) {
                    volIcon = ""
                } else if (volumeVal >= 60) {
                    volIcon = ""
                } else if (volumeVal >= 25) {
                    volIcon = ""
                } else {
                    volIcon = ""
                }
            }
        }
    }

    // Refresh Volume every 2 seconds
    Timer {
        interval: 2000; running: true; repeat: true
        triggeredOnStart: true
        onTriggered: volProc.running = true
    }

    // Volume Pill
    Rectangle {
        width: 76
        height: 30
        radius: 15
        color: Style.surface

        Row {
            anchors.centerIn: parent
            spacing: 6
            
            Text {
                text: volIcon
                color: isMuted ? Style.urgent : Style.highlight
                font.pixelSize: 14
            }
            
            Text {
                text: volumeVal + "%"
                color: Style.text
                font.bold: true
                font.pixelSize: 12
            }
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                var p = Qt.createQmlObject('import Quickshell.Io; Process { command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"] }', parent);
                p.running = true;
                volProc.running = true; 
            }
        }
    }

    // --- 2. Network Indicator ---
    property string netIcon: "󰤭" 
    property string netLabel: "Offline"
    property bool netActive: false

    Process {
        id: netProc
        command: ["nmcli", "-t", "-f", "TYPE,STATE,NAME", "connection", "show", "--active"]
        
        // FIX: Use StdioCollector here too
        stdout: StdioCollector {
            onTextChanged: {
                var output = text.trim()
                var lines = output.split("\n")
                
                var found = false
                
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i]
                    if (line === "") continue

                    // Parse your exact output: "802-3-ethernet:activated:Wired connection 1"
                    if (line.includes("wireless") || line.includes("wifi")) {
                        netIcon = ""
                        var parts = line.split(":")
                        netLabel = parts.length >= 3 ? parts[2] : "Wi-Fi"
                        netActive = true
                        found = true
                        break 
                    } 
                    else if (line.includes("ethernet") || line.includes("802-3-ethernet")) {
                        netIcon = "󰈀"
                        netLabel = "Wired"
                        netActive = true
                        found = true
                    }
                }

                if (!found) {
                    netIcon = "󰤭"
                    netLabel = "Offline"
                    netActive = false
                }
            }
        }
    }

    Timer {
        interval: 5000; running: true; repeat: true
        triggeredOnStart: true
        onTriggered: netProc.running = true
    }

    // Network Pill
    Rectangle {
        width: netLabel.length > 6 ? 100 : 80
        height: 30
        radius: 15
        color: Style.surface
        visible: true 

        Row {
            anchors.centerIn: parent
            spacing: 8
            
            Text {
                text: netIcon
                color: netActive ? "#a6e3a1" : Style.urgent
                font.pixelSize: 14
            }
            
            Text {
                text: netLabel
                color: Style.text
                font.bold: true
                font.pixelSize: 12
                elide: Text.ElideRight
                width: 50
            }
        }
    }
}
