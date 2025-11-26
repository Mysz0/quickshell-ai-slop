import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import "../theme"
import "../components"

BarModule {
    id: root

    width: layout.implicitWidth + 24 // Padding

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 8

        // Tray Component
        Tray {
            id: sysTray
            Layout.alignment: Qt.AlignVCenter
        }

        // Separator Dot
        Text {
            text: "•"
            color: "#585b70"
            font.pixelSize: 18
            verticalAlignment: Text.AlignVCenter
            visible: sysTray.width > 0
            Layout.alignment: Qt.AlignVCenter
            Layout.bottomMargin: 1
        }

        // --- Icons ---
        
        // Audio Icon
        Item {
            Layout.preferredWidth: audioIcon.implicitWidth
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignVCenter
            
            property var sink: Pipewire.defaultAudioSink
            property bool isMuted: sink ? sink.audio.muted : false
            property int volume: sink ? Math.round(sink.audio.volume * 100) : 0

            Text {
                id: audioIcon
                anchors.centerIn: parent
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
                
                text: parent.isMuted ? "󰝟" : (parent.volume > 50 ? "" : (parent.volume > 0 ? "" : ""))
                color: parent.isMuted ? Style.urgent : "#cdd6f4"
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (GlobalState.topBarWindow) {
                        var pos = audioIcon.mapToItem(GlobalState.topBarWindow.contentItem, audioIcon.width/2, 0)
                        GlobalState.volumeX = pos.x
                    }
                    GlobalState.togglePopup("volume")
                }
            }
        }

        // Bluetooth Icon
        Item {
            Layout.preferredWidth: btText.implicitWidth
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignVCenter
            
            Text {
                id: btText
                anchors.centerIn: parent
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
                text: ""
                color: "#cdd6f4"
                verticalAlignment: Text.AlignVCenter
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (GlobalState.topBarWindow) {
                        var pos = btText.mapToItem(GlobalState.topBarWindow.contentItem, btText.width/2, 0)
                        GlobalState.bluetoothX = pos.x
                    }
                    GlobalState.togglePopup("bluetooth")
                }
            }
        }

        // Network Icon
        Item {
            Layout.preferredWidth: netIcon.implicitWidth
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignVCenter

            Text {
                id: netIcon
                anchors.centerIn: parent
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
                
                property bool isEthernet: false
                property bool isWifi: false
                property int signal: 0
                
                // Icon Logic: Ethernet -> Wifi -> Disconnected
                text: {
                    if (isEthernet) return "󰈀" // Ethernet Connected
                    if (isWifi) {
                        if (signal >= 80) return "󰤨"
                        if (signal >= 60) return "󰤥"
                        if (signal >= 40) return "󰤢"
                        if (signal >= 20) return "󰤟"
                        return "󰤯"
                    }
                    return "󰤭" // Disconnected
                }
                
                // Color Logic: Active -> Urgent (Red/Pink)
                color: (isEthernet || isWifi) ? "#cdd6f4" : Style.urgent
                verticalAlignment: Text.AlignVCenter

                Process {
                    id: netProc
                    // Checks TYPE, STATE, and SIGNAL for all devices
                    command: ["nmcli", "-t", "-f", "TYPE,STATE,SIGNAL", "device"]
                    stdout: StdioCollector {
                        onTextChanged: {
                            var eth = false
                            var wifi = false
                            var sig = 0
                            
                            // Parse output line by line
                            var lines = text.split("\n")
                            for (var i = 0; i < lines.length; i++) {
                                var line = lines[i].trim()
                                if (line === "") continue
                                
                                var parts = line.split(":")
                                if (parts.length < 2) continue
                                
                                var type = parts[0]
                                var state = parts[1]
                                var signalVal = parts[2]
                                
                                // Check for Ethernet (loosened check)
                                if (type.indexOf("ethernet") !== -1 && state === "connected") {
                                    eth = true
                                }
                                
                                // Check for Wi-Fi
                                if (type.indexOf("wifi") !== -1 && state === "connected") {
                                    wifi = true
                                    sig = parseInt(signalVal) || 0
                                }
                            }
                            
                            netIcon.isEthernet = eth
                            netIcon.isWifi = wifi
                            netIcon.signal = sig
                        }
                    }
                }
                
                Timer {
                    interval: 2000 // Check every 2 seconds
                    running: true
                    repeat: true
                    triggeredOnStart: true
                    onTriggered: netProc.running = true
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    netProc.running = true
                    if (GlobalState.topBarWindow) {
                        var pos = netIcon.mapToItem(GlobalState.topBarWindow.contentItem, netIcon.width/2, 0)
                        GlobalState.wifiX = pos.x
                    }
                    GlobalState.togglePopup("wifi")
                }
            }
        }
    }
}
