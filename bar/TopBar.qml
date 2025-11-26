import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../theme"

PanelWindow {
    id: root
    
    implicitHeight: 55 
    
    anchors {
        top: true
        left: true
        right: true
    }
    color: "transparent"
    
    Component.onCompleted: GlobalState.topBarWindow = root
    property var monitor: Hyprland.monitorFor(root.screen)

    // The Main Floating Pill Bar
    Rectangle {
        id: barBackground
        anchors {
            fill: parent
            margins: 10 
            topMargin: 10
            bottomMargin: 5
        }
        
        radius: 12 
        color: "#1e1e2e"
        border.width: 1
        border.color: "#313244"

        // --- Left: Clock ---
        Row {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            Clock {}
        }

        // --- Center: Workspaces ---
        Workspaces {
            anchors.centerIn: parent
            monitor: root.monitor
        }

        // --- Right: Indicators + Dashboard ---
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 15

            SystemIndicators {}

            // Dashboard Toggle Button (Burger Menu)
            Rectangle {
                id: dashBtn
                
                // Matches standard BarModule height
                width: 32 
                height: 30 
                radius: 12
                
                // Add border to match other modules
                border.width: 1
                border.color: "#45475a"
                
                // Use Surface color when inactive to match the theme
                color: GlobalState.showDashboard ?
                        "#cba6f7" : Style.surface

                Text {
                    anchors.centerIn: parent
                    text: ""
                    color: GlobalState.showDashboard ?
                           "#11111b" : "#cdd6f4"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var pos = dashBtn.mapToItem(root.contentItem, dashBtn.width/2, 0)
                        GlobalState.dashboardX = pos.x
                        GlobalState.togglePopup("dashboard")
                    }
                }
            }
        }
    }
}
