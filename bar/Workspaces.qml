import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../theme"

RowLayout {
    spacing: 6

    Repeater {
        model: Hyprland.workspaces

        // Fixed: Wrapper Item to filter out negative workspaces (special/scratchpads)
        Item {
            // Only render if ID is valid (0 or positive)
            visible: modelData.id >= 0
            width: visible ? 30 : 0
            height: visible ? 30 : 0
            
            Rectangle {
                anchors.fill: parent
                radius: 15
                
                // Fixed: Safe check for focusedWorkspace to prevent "null" error
                readonly property bool isActive: Hyprland.focusedWorkspace 
                                                 && Hyprland.focusedWorkspace.id === modelData.id

                color: isActive ? Style.highlight : Style.surface

                Text {
                    anchors.centerIn: parent
                    text: modelData.id
                    color: parent.isActive ? "#11111b" : Style.text
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch(`workspace ${modelData.id}`)
                }
            }
        }
    }
}
