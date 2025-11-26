// components/ToggleSwitch.qml
import QtQuick
import "../theme"

Rectangle {
    id: root
    implicitWidth: 44
    implicitHeight: 24
    radius: 12
    
    property bool checked: false
    signal toggled(bool state)

    color: checked ? Style.highlight : Style.surface

    Rectangle {
        x: root.checked ? root.width - width - 2 : 2
        anchors.verticalCenter: parent.verticalCenter
        width: 20
        height: 20
        radius: 10
        color: "#ffffff"
        
        Behavior on x { NumberAnimation { duration: 200 } }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.checked = !root.checked
            root.toggled(root.checked)
        }
    }
}
