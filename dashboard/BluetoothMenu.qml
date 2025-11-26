import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import "../theme"

Item {
    id: btMenu
    
    // Use the native Bluetooth singleton provided by Quickshell
    // This requires the Quickshell.Bluetooth module
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        
        // --- Top Bar: Scan Toggle ---
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "Devices"
                color: Style.text
                font.bold: true
                Layout.fillWidth: true
            }

            Rectangle {
                implicitWidth: 60
                implicitHeight: 24
                radius: 12
                color: (Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.discovering) 
                       ? Style.highlight 
                       : Style.surface

                Text {
                    anchors.centerIn: parent
                    text: (Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.discovering) 
                          ? "Scanning" 
                          : "Scan"
                    color: (Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.discovering) 
                           ? "#11111b" 
                           : Style.text
                    font.pixelSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (Bluetooth.defaultAdapter) {
                            Bluetooth.defaultAdapter.discovering = !Bluetooth.defaultAdapter.discovering
                        }
                    }
                }
            }
        }

        // --- Device List ---
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 4

            // The native model contains all known/scanned devices
            model: Bluetooth.devices

            delegate: Rectangle {
                width: ListView.view.width
                height: 40
                color: Style.surface
                radius: 6

                // modelData refers to the specific BluetoothDevice object
                // We use it to bind directly to properties like .name and .connected

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 10
                    
                    // Device Name
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        
                        Text {
                            text: modelData.name || modelData.address
                            color: Style.text
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: modelData.address
                            color: "#6c7086" // Subtext color
                            font.pixelSize: 10
                            visible: modelData.name !== modelData.address
                        }
                    }

                    // Status / Action Button
                    Rectangle {
                        implicitWidth: 70
                        implicitHeight: 24
                        radius: 6
                        
                        color: {
                            if (modelData.connected) return "#a6e3a1" // Green
                            if (modelData.pairing) return "#f9e2af"   // Yellow
                            return "#45475a" // Dark Grey
                        }

                        Text {
                            anchors.centerIn: parent
                            text: {
                                if (modelData.connected) return "Connected"
                                if (modelData.pairing) return "Pairing..."
                                return "Connect"
                            }
                            color: modelData.connected ? "#11111b" : "#cdd6f4"
                            font.pixelSize: 11
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (modelData.connected) {
                                    modelData.disconnect()
                                } else {
                                    // If not paired, we might need to pair first, 
                                    // but connect() often handles this or initiates it.
                                    if (!modelData.paired) {
                                        modelData.pair()
                                    } else {
                                        modelData.connect()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
