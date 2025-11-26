import QtQuick
import Quickshell
import "../theme"

PanelWindow {
    id: root
    
    // Fixed: Use implicitHeight to avoid the warning
    implicitHeight: 46 
    
    anchors {
        top: true
        left: true
        right: true
    }
    
    color: "transparent"

    // Background Panel
    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        color: "#1e1e2e" // Dark background
        radius: 10
        opacity: 0.9
        
        // --- 1. Left: Clock ---
        Row {
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10
            
            Clock {}
        }

        // --- 2. Center: Workspaces ---
        Item {
            anchors.centerIn: parent
            width: workspaces.width
            height: parent.height
            
            Workspaces {
                id: workspaces
            }
        }

        // --- 3. Right: Indicators & Menu Button ---
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            spacing: 15

            // Your existing indicators (Volume/Network)
            SystemIndicators {}

            // The Dashboard Button
            Rectangle {
                width: 30; height: 30
                radius: 15
                color: GlobalState.showDashboard ? "#cba6f7" : "#313244"

                Text {
                    anchors.centerIn: parent
                    text: "M" // Simple Text Icon for now
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: GlobalState.showDashboard = !GlobalState.showDashboard
                }
            }
        }
    }
}
