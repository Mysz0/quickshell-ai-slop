import QtQuick
import QtQuick.Controls
import "../theme"

Rectangle {
    width: timeText.implicitWidth + 24
    height: 30
    radius: 15
    color: Style.surface

    Text {
        id: timeText
        anchors.centerIn: parent
        text: Qt.formatDateTime(new Date(), "hh:mm")
        color: Style.text
        font.bold: true
    }
    
    // Fixed: Now ToolTip works because we imported QtQuick.Controls
    ToolTip {
        visible: ma.containsMouse
        text: Qt.formatDateTime(new Date(), "ddd, MMM d")
        delay: 500
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
    }
}
