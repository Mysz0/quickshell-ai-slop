import QtQuick
import Quickshell
import "../theme"

PanelWindow {
    id: root
    implicitHeight: 46 
    anchors {
        top: true
        left: true
        right: true
    }
    color: "transparent"

    // Master Container
    Item {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        // --- 1. LEFT PILL (Clock) ---
        // Clock.qml already has a Rectangle background, so we just place it.
        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            Clock {}
        }

        // --- 2. CENTER PILL (Workspaces) ---
        Rectangle {
            anchors.centerIn: parent
            height: 36
            width: workspaces.width + 20 // Padding
            color: "#1e1e2e" // Background color
            radius: 18
            border.color: "#313244"
            border.width: 1

            Workspaces {
                id: workspaces
                anchors.centerIn: parent
            }
        }

        // --- 3. RIGHT PILL (Indicators & Menu) ---
        Rectangle {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: 36
            width: rightRow.width + 24 // Padding
            color: "#1e1e2e"
            radius: 18
            border.color: "#313244"
            border.width: 1

            Row {
                id: rightRow
                anchors.centerIn: parent
                spacing: 12

                SystemIndicators {}

                // Dashboard Toggle Button
                Rectangle {
                    width: 28; height: 28
                    radius: 14
                    color: GlobalState.showDashboard ? "#cba6f7" : "#45475a"

                    Text {
                        anchors.centerIn: parent
                        text: "" // Menu Icon
                        color: GlobalState.showDashboard ? "#11111b" : "#cdd6f4"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: GlobalState.showDashboard = !GlobalState.showDashboard
                    }
                }
            }
        }
    }
}
