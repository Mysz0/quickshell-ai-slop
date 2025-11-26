import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../theme"

PopupWindow {
    id: root
    
    anchor.window: GlobalState.topBarWindow
    anchor.rect.x: GlobalState.volumeX - (width / 2)
    anchor.rect.y: GlobalState.topBarWindow ? GlobalState.topBarWindow.height + 4 : 50
    
    implicitWidth: 250
    implicitHeight: 60
    
    visible: GlobalState.showVolume
    color: "transparent"
    
    Rectangle {
        anchors.fill: parent
        color: "#1e1e2e"
        radius: 12
        border.color: "#313244"
        border.width: 1
        layer.enabled: true
        layer.samples: 4
        
        // Animation Properties
        transformOrigin: Item.Top
        scale: root.visible ? 1.0 : 0.9
        opacity: root.visible ? 1.0 : 0.0
        
        Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10
            
            Text {
                text: ""
                color: Style.highlight
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
            }

            Slider {
                id: volSlider
                Layout.fillWidth: true
                from: 0; to: 150; stepSize: 1
                
                background: Rectangle {
                    x: volSlider.leftPadding
                    y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2
                    implicitWidth: 200; implicitHeight: 6
                    width: volSlider.availableWidth; height: implicitHeight
                    radius: 3; color: "#45475a"
                    Rectangle {
                        width: volSlider.visualPosition * parent.width
                        height: parent.height
                        color: Style.highlight; radius: 3
                    }
                }
                handle: Rectangle {
                    x: volSlider.leftPadding + volSlider.visualPosition * (volSlider.availableWidth - width)
                    y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2
                    implicitWidth: 16; implicitHeight: 16
                    radius: 8
                    color: volSlider.pressed ? "#f0c6c6" : "#f5e0dc"
                }
                onMoved: {
                    volSet.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", (value / 100).toFixed(2)]
                    volSet.running = true
                    volText.text = Math.round(value) + "%"
                }
            }

            Text {
                id: volText
                text: "0%"
                color: Style.text
                font.bold: true
                Layout.minimumWidth: 35
                horizontalAlignment: Text.AlignRight
            }
        }
    }

    Process { id: volSet; command: ["true"] }
    Process {
        id: volGet
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        running: root.visible
        stdout: StdioCollector {
            onTextChanged: {
                var match = text.match(/Volume:\s+([\d\.]+)/)
                if (match && match.length >= 2) {
                    var currentVol = Math.round(parseFloat(match[1]) * 100)
                    if (!volSlider.pressed) {
                        volSlider.value = currentVol
                        volText.text = currentVol + "%"
                    }
                }
            }
        }
    }
    Timer { interval: 1000; running: root.visible; repeat: true; onTriggered: volGet.running = true }
    onVisibleChanged: if (visible) volGet.running = true
}
