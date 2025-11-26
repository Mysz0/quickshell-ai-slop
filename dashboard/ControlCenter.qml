import QtQuick
import QtQuick.Layouts
import Quickshell
import "../theme"

PanelWindow {
    id: root
    
    // Position: Top Right
    anchors {
        top: true
        right: true
    }

    // Offset from the edges (Gap)
    margins {
        top: 55
        right: 10
    }

    width: 380
    height: 600
    
    // REMOVED: layer: Layer.Overlay (This was causing the crash)
    
    visible: GlobalState.showDashboard
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: "#1e1e2e"
        radius: 12
        border.color: "#313244"
        border.width: 2
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10

            // Header
            Text {
                text: "Control Center"
                color: "#cdd6f4"
                font.pixelSize: 18
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#313244" }

            // --- Wi-Fi Section (Flexible) ---
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true 
                
                Text { text: "  Wi-Fi"; color: "#89b4fa"; font.bold: true }
                
                WifiMenu {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#313244" }

            // --- Bluetooth Section (Flexible) ---
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true 
                
                Text { text: "  Bluetooth"; color: "#b4befe"; font.bold: true }

                BluetoothMenu {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }
}
