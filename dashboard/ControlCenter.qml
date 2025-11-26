import QtQuick
import QtQuick.Layouts
import Quickshell
import "../theme"
import "../components" // Import your components folder

PanelWindow {
    id: root
    
    // Position: Top Right with margins
    anchors {
        top: true
        right: true
    }
    margins {
        top: 55
        right: 10
    }

    width: 380
    height: 600
    
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
            anchors.margins: 20
            spacing: 15

            // --- Title ---
            Text {
                text: "Control Center"
                color: "#cdd6f4"
                font.pixelSize: 20
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#45475a" }

            // --- Wi-Fi Section ---
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                // Header with Switch
                RowLayout {
                    Layout.fillWidth: true
                    
                    Text { 
                        text: "  Wi-Fi"
                        color: "#a6e3a1"
                        font.pixelSize: 16
                        font.bold: true
                        Layout.fillWidth: true
                    }

                    ToggleSwitch {
                        id: wifiSwitch
                        checked: true // You can bind this to actual status later
                        onToggled: (state) => {
                            // Logic to run: nmcli radio wifi on/off
                            console.log("Wi-Fi Toggled: " + state)
                        }
                    }
                }
                
                // Pass the switch state to the menu to show/hide list
                WifiMenu {
                    visible: wifiSwitch.checked
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#45475a" }

            // --- Bluetooth Section ---
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                // Header with Switch
                RowLayout {
                    Layout.fillWidth: true
                    
                    Text { 
                        text: "  Bluetooth"
                        color: "#89b4fa"
                        font.pixelSize: 16
                        font.bold: true
                        Layout.fillWidth: true
                    }

                    ToggleSwitch {
                        id: btSwitch
                        checked: true
                        onToggled: (state) => {
                            // Logic to run: rfkill unblock/block bluetooth
                            console.log("Bluetooth Toggled: " + state)
                        }
                    }
                }

                BluetoothMenu {
                    visible: btSwitch.checked
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }
}
