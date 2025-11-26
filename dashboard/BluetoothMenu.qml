import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import "../theme"

Item {
    id: btMenu
    
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
                
                // [ANIMATED] Scan Button Scale
                scale: scanMa.containsMouse ? 1.05 : 1.0
                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

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
                    id: scanMa
                    anchors.fill: parent
                    hoverEnabled: true
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

            model: Bluetooth.devices

            delegate: Rectangle {
                width: ListView.view.width
                implicitHeight: contentLayout.implicitHeight + 16
                
                color: Style.surface
                radius: 6

                property bool isConnecting: false
                property bool connectionError: false

                Connections {
                    target: modelData
                    function onConnectedChanged() {
                        if (modelData.connected) {
                            isConnecting = false
                            connectionError = false
                            connectTimeout.stop()
                        }
                    }
                }

                Timer {
                    id: connectTimeout
                    interval: 10000
                    onTriggered: {
                        isConnecting = false
                        connectionError = true
                        errorReset.start()
                    }
                }

                Timer {
                    id: errorReset
                    interval: 2000
                    onTriggered: connectionError = false
                }

                RowLayout {
                    id: contentLayout
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10
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
                            wrapMode: Text.Wrap 
                        }
                        
                        Text {
                            text: modelData.address
                            color: "#6c7086"
                            font.pixelSize: 10
                            visible: modelData.name !== modelData.address
                        }
                    }

                    // [ANIMATED] Connect Button
                    Rectangle {
                        implicitWidth: 85
                        implicitHeight: 24
                        radius: 6
                        
                        // Hover Animation
                        scale: connectMa.containsMouse ? 1.05 : 1.0
                        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
                        
                        color: {
                            if (connectionError) return Style.urgent
                            if (modelData.connected) return "#a6e3a1"
                            if (isConnecting || modelData.pairing) return "#f9e2af"
                            return "#45475a"
                        }

                        Text {
                            anchors.centerIn: parent
                            text: {
                                if (connectionError) return "Failed"
                                if (modelData.connected) return "Connected"
                                if (isConnecting) return "Connecting..."
                                if (modelData.pairing) return "Pairing..."
                                return "Connect"
                            }
                            color: (modelData.connected || isConnecting || connectionError) ? "#11111b" : "#cdd6f4"
                            font.pixelSize: 11
                            font.bold: true
                        }

                        MouseArea {
                            id: connectMa
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: !isConnecting
                            onClicked: {
                                if (modelData.connected) {
                                    modelData.disconnect()
                                } else {
                                    isConnecting = true
                                    connectionError = false
                                    connectTimeout.start()
                                    if (!modelData.paired) {
                                        modelData.pair()
                                    } 
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
