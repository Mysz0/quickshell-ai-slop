import QtQuick
import QtQuick.Layouts
import Quickshell
import "../theme"

PanelWindow {
    id: root
    
    // Use margins instead of anchors for the window gap
    anchors {
        top: true
        right: true
    }
    
    // Correct way to set window margins in newer Quickshell
    // If 'margins' property fails again, assume anchors + margin values
    margins.top: 55
    margins.right: 10

    width: 380
    height: 500
    visible: GlobalState.showDashboard
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: "#1e1e2e" // Base
        radius: 12
        border.color: "#89b4fa" // Highlight border
        border.width: 1
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Text {
                text: "Control Center"
                color: "#cdd6f4"
                font.pixelSize: 20
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#313244" }

            // --- Wi-Fi ---
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                Text { 
                    text: " Wi-Fi Networks" 
                    color: "#a6e3a1"
                    font.bold: true 
                }
                
                WifiMenu {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#313244" }

            // --- Bluetooth ---
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                Text { 
                    text: " Bluetooth Devices" 
                    color: "#89b4fa"
                    font.bold: true 
                }

                BluetoothMenu {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }
}
