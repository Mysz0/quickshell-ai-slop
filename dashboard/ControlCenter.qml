import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import "../theme"
import "../components"

PopupWindow {
    id: root
    
    anchor.window: GlobalState.topBarWindow
    anchor.rect.x: GlobalState.dashboardX + 14 - width
    anchor.rect.y: GlobalState.topBarWindow ? GlobalState.topBarWindow.height + 4 : 50

    implicitWidth: 380
    implicitHeight: 600
    
    visible: GlobalState.showDashboard
    color: "transparent"
    
    Process { id: wifiProc; command: ["true"] }
    Process { id: btProc; command: ["true"] }
    Process { id: powerProc; command: ["true"] } 

    property int volumeVal: 0
    
    Process { id: volGet; command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]; running: root.visible; stdout: StdioCollector { onTextChanged: { var match = text.match(/Volume:\s+([\d\.]+)/); if(match) { var v = Math.round(parseFloat(match[1])*100); if(!volSlider.pressed) volSlider.value = v; root.volumeVal = v; } } } }
    Process { id: volSet; command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", (volSlider.value / 100).toFixed(2)] }
    Timer { interval: 2000; running: root.visible; repeat: true; onTriggered: volGet.running = true }

    property var mprisPlayer: Mpris.players.length > 0 ? Mpris.players[0] : null

    Rectangle {
        anchors.fill: parent
        color: "#1e1e2e"
        radius: 12
        border.color: "#313244"
        border.width: 2
        layer.enabled: true
        layer.samples: 4
        
        transformOrigin: Item.TopRight
        scale: root.visible ? 1.0 : 0.9
        opacity: root.visible ? 1.0 : 0.0
        Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Text {
                text: "Control Center"
                color: "#cdd6f4"
                font.pixelSize: 20
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#45475a" }

            // --- Media Player ---
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 110
                visible: root.mprisPlayer !== null
                color: Style.surface
                radius: 12
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 15

                    Rectangle {
                        Layout.preferredWidth: 90
                        Layout.preferredHeight: 90
                        radius: 8
                        color: "#1e1e2e"
                        clip: true
                        
                        Image {
                            anchors.fill: parent
                            source: root.mprisPlayer ? root.mprisPlayer.trackArtUrl : "" 
                            fillMode: Image.PreserveAspectCrop
                            
                            Text {
                                anchors.centerIn: parent
                                visible: parent.status !== Image.Ready
                                text: ""
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 32
                                color: "#585b70"
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 5

                        Text {
                            text: root.mprisPlayer ? root.mprisPlayer.trackTitle : "No Media"
                            color: Style.text
                            font.bold: true
                            font.pixelSize: 14
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: (root.mprisPlayer && root.mprisPlayer.trackArtists.length > 0) ? root.mprisPlayer.trackArtists[0] : ""
                            color: "#a6adc8"
                            font.pixelSize: 12
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        
                        Item { Layout.fillHeight: true }

                        RowLayout {
                            spacing: 20
                            Layout.alignment: Qt.AlignHCenter

                            // [ANIMATED] Previous
                            Text {
                                text: "󰒮"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 20
                                color: maPrev.containsMouse ? Style.highlight : Style.text
                                Behavior on color { ColorAnimation { duration: 150 } }
                                
                                MouseArea { 
                                    id: maPrev
                                    anchors.fill: parent; 
                                    hoverEnabled: true
                                    onClicked: if(root.mprisPlayer) root.mprisPlayer.previous() 
                                }
                            }

                            // [ANIMATED] Play/Pause
                            Rectangle {
                                implicitWidth: 32; implicitHeight: 32; radius: 16
                                color: Style.highlight
                                
                                scale: maPlay.containsMouse ? 1.1 : 1.0
                                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

                                Text {
                                    anchors.centerIn: parent
                                    text: (root.mprisPlayer && root.mprisPlayer.playbackState === 1) ? "󰏤" : "󰐊"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 16
                                    color: "#1e1e2e"
                                }
                                MouseArea { 
                                    id: maPlay
                                    anchors.fill: parent; 
                                    hoverEnabled: true
                                    onClicked: if(root.mprisPlayer) root.mprisPlayer.togglePlaying() 
                                }
                            }

                            // [ANIMATED] Next
                            Text {
                                text: "󰒭"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 20
                                color: maNext.containsMouse ? Style.highlight : Style.text
                                Behavior on color { ColorAnimation { duration: 150 } }

                                MouseArea { 
                                    id: maNext
                                    anchors.fill: parent; 
                                    hoverEnabled: true
                                    onClicked: if(root.mprisPlayer) root.mprisPlayer.next() 
                                }
                            }
                        }
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#45475a"; visible: root.mprisPlayer !== null }

            // --- Volume ---
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 5
                Text { text: "   Volume"; color: "#f9e2af"; font.pixelSize: 16; font.bold: true }
                RowLayout {
                    Layout.fillWidth: true
                    Slider {
                        id: volSlider
                        Layout.fillWidth: true
                        from: 0; to: 150; stepSize: 1
                        background: Rectangle { x: volSlider.leftPadding; y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2; implicitWidth: 200; implicitHeight: 6; width: volSlider.availableWidth; height: implicitHeight; radius: 3; color: "#45475a"; Rectangle { width: volSlider.visualPosition * parent.width; height: parent.height; color: "#f9e2af"; radius: 3 } }
                        handle: Rectangle { x: volSlider.leftPadding + volSlider.visualPosition * (volSlider.availableWidth - width); y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2; implicitWidth: 20; implicitHeight: 20; radius: 10; color: volSlider.pressed ? "#f0c6c6" : "#f5e0dc"; border.color: "#1e1e2e" }
                        onMoved: { volSet.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", (value / 100).toFixed(2)]; volSet.running = true; root.volumeVal = Math.round(value) }
                    }
                    Text { text: root.volumeVal + "%"; color: Style.text; font.bold: true; Layout.minimumWidth: 40; horizontalAlignment: Text.AlignRight }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#45475a" }

            // --- Wi-Fi ---
            ColumnLayout {
                Layout.fillWidth: true; Layout.fillHeight: true; spacing: 10
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "   Wi-Fi"; color: "#a6e3a1"; font.pixelSize: 16; font.bold: true; Layout.fillWidth: true }
                    ToggleSwitch { id: wifiSwitch; checked: true; onToggled: (state) => { wifiProc.command = ["nmcli", "radio", "wifi", state ? "on" : "off"]; wifiProc.running = true } }
                }
                WifiMenu { visible: wifiSwitch.checked; Layout.fillWidth: true; Layout.fillHeight: true }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#45475a" }

            // --- Bluetooth ---
            ColumnLayout {
                Layout.fillWidth: true; Layout.fillHeight: true; spacing: 10
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "  Bluetooth"; color: "#89b4fa"; font.pixelSize: 16; font.bold: true; Layout.fillWidth: true }
                    ToggleSwitch { id: btSwitch; checked: true; onToggled: (state) => { btProc.command = ["rfkill", state ? "unblock" : "block", "bluetooth"]; btProc.running = true } }
                }
                BluetoothMenu { visible: btSwitch.checked; Layout.fillWidth: true; Layout.fillHeight: true }
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: "#45475a" }

            // --- Power Controls ---
            RowLayout {
                Layout.fillWidth: true
                spacing: 15
                
                // [ANIMATED] Power Button Component
                component PowerBtn: Rectangle {
                    property string icon
                    property string cmd
                    property color iconColor: Style.text
                    
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    radius: 8
                    
                    // Scale and Color animations on hover
                    scale: ma.containsMouse ? 1.05 : 1.0
                    color: ma.containsMouse ? Qt.lighter(Style.surface, 1.2) : Style.surface
                    
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
                    Behavior on color { ColorAnimation { duration: 150 } }
                    
                    Text {
                        anchors.centerIn: parent
                        text: parent.icon
                        color: parent.iconColor
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 20
                    }
                    
                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            powerProc.command = ["bash", "-c", parent.cmd]
                            powerProc.running = true
                        }
                    }
                }

                PowerBtn { icon: ""; cmd: "loginctl lock-session" }
                PowerBtn { icon: ""; cmd: "systemctl reboot" }
                PowerBtn { icon: ""; iconColor: Style.urgent; cmd: "systemctl poweroff" }
            }
        }
    }
}
