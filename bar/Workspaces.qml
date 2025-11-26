import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import "../theme"
import "../components"
BarModule {
    id: root
    property var monitor

    width: row.implicitWidth + 24

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: Hyprland.workspaces

            Rectangle {
                id: dot
                
                readonly property var workspace: modelData
                readonly property bool isActive: workspace.active
                readonly property bool isVisibleWs: workspace.id !== -98
                
                visible: isVisibleWs
                
                implicitHeight: 10
                implicitWidth: isVisibleWs ? (isActive ? 24 : 10) : 0
                
                radius: 5
                color: isActive ? Style.highlight : "#a6adc8"
                opacity: isActive ? 1.0 : 0.5

                Behavior on implicitWidth { NumberAnimation { duration: 300; easing.type: Easing.OutExpo } }
                Behavior on color { ColorAnimation { duration: 200 } }
                Behavior on opacity { NumberAnimation { duration: 200 } }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + dot.workspace.id)
                    // ToolTip removed as requested
                }
            }
        }
    }
}
