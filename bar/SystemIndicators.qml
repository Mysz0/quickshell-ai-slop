import QtQuick
import Quickshell
import Quickshell.Io

Row {
    spacing: 10
    
    // --- Volume Indicator ---
    property int volumeVal: 0
    property bool isMuted: false

    Process {
        id: volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        
        // FIX: Use onStdoutChanged because stdout is a property
        onStdoutChanged: {
            var text = volProc.stdout.trim()
            var parts = text.split(" ")
            if (parts.length > 1) {
                // Parse "0.45" -> 45
                volumeVal = Math.round(parseFloat(parts[1]) * 100)
            }
            isMuted = text.includes("MUTED")
        }
    }

    Timer {
        interval: 2000; running: true; repeat: true
        triggeredOnStart: true
        onTriggered: volProc.running = true
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: "VOL: " + volumeVal + "%"
        color: isMuted ? "#f38ba8" : "#cdd6f4"
    }

    // --- Network Indicator (Simple Text) ---
    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: "NET"
        color: "#a6e3a1"
    }
}
