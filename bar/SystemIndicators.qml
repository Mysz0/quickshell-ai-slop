import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"

Row {
    spacing: 8
    
    // --- 1. Volume Indicator ---
    property int volumeVal: 0
    property bool isMuted: false
    property string volIcon: "" // Default icon

    Process {
        id: volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        
        onStdoutChanged: {
            var text = volProc.stdout.trim()
            // Output format: "Volume: 0.45 [MUTED]"
            
            // 1. Check Muted
            isMuted = text.includes("MUTED")

            // 2. Parse Volume
            var parts = text.split(" ")
            if (parts.length > 1) {
                // "0.45" -> 45
                volumeVal = Math.round(parseFloat(parts[1]) * 100)
            }
            
            // 3. Update Icon
            if (isMuted) {
                volIcon = "" // Muted
            } else if (volumeVal >= 70) {
                volIcon = "" // High
            } else if (volumeVal >= 30) {
                volIcon = "" // Medium
            } else {
                volIcon = "" // Low
            }
        }
    }

    // Refresh Volume every 2s
    Timer {
        interval: 2000; running: true; repeat: true
        triggeredOnStart: true
        onTriggered: volProc.running = true
    }

    // Volume Pill
    Rectangle {
        width: 70
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
        
        // Simple click to toggle mute (optional extra)
        MouseArea {
            anchors.fill: parent
            onClicked: {
               // Fire and forget mute toggle
               var p = Qt.createQmlObject('import Quickshell.Io; Process { command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"] }', parent);
               p.running = true;
               volProc.running = true; // Force update UI
            }
        }
    }

    // --- 2. Network Indicator ---
    property string netIcon: "󰤭" // Disconnected
    property string netState: "Offline"
    property bool netActive: false

    Process {
        id: netProc
        // Get active connection types: "802-11-wireless" or "802-3-ethernet"
        command: ["nmcli", "-t", "-f", "TYPE,STATE", "connection", "show", "--active"]
        
        onStdoutChanged: {
            var out = netProc.stdout.trim()
            
            if (out.includes("wireless")) {
                netIcon = "" 
                netState = "Wi-Fi"
                netActive = true
            } else if (out.includes("ethernet")) {
                netIcon = "󰈀"
                netState = "Wired"
                netActive = true
            } else {
                netIcon = "󰤭"
                netState = "Offline"
                netActive = false
            }
        }
    }

    // Refresh Network every 5s
    Timer {
        interval: 5000; running: true; repeat: true
        triggeredOnStart: true
        onTriggered: netProc.running = true
    }

    // Network Pill
    Rectangle {
        visible: true // Always show, or set to 'netActive' to hide when offline
        width: 80
        height: 30
        radius: 15
        color: Style.surface

        Row {
            anchors.centerIn: parent
            spacing: 6
            
            Text {
                text: netIcon
                color: netActive ? "#a6e3a1" : "#f38ba8" // Green if active, Red if off
                font.pixelSize: 14
                font.family: "Nerd Font" // Ensure you have a Nerd Font installed
            }
            
            Text {
                text: netState
                color: Style.text
                font.bold: true
                font.pixelSize: 12
            }
        }
    }
}
