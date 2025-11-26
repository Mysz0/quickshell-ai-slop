import QtQuick
import QtQuick.Controls
import "../theme"
import "../components"

BarModule {
    id: root
    property var monitor

    // Increased width slightly to accommodate the date
    width: timeText.implicitWidth + 30 

    property var currentTime: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.currentTime = new Date()
    }

    Text {
        id: timeText
        anchors.centerIn: parent
        text: Qt.formatDateTime(root.currentTime, "ddd d MMM  hh:mm")
        color: "#cdd6f4"
        font.bold: true
        font.pixelSize: 14
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: ma
        anchors.fill: parent
    }
}
