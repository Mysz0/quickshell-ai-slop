import QtQuick
import Quickshell
import "../theme"
import "../dashboard"

PopupWindow {
    id: root
    
    anchor.window: GlobalState.topBarWindow
    anchor.rect.x: GlobalState.wifiX - (width / 2)
    anchor.rect.y: GlobalState.topBarWindow ? GlobalState.topBarWindow.height + 4 : 50
    
    implicitWidth: 300
    implicitHeight: 400
    
    visible: GlobalState.showWifi
    color: "transparent"
    
    Rectangle {
        anchors.fill: parent
        color: "#1e1e2e"
        radius: 12
        border.color: "#313244"
        border.width: 1
        layer.enabled: true
        layer.samples: 4

        // Animations
        transformOrigin: Item.Top
        scale: root.visible ? 1.0 : 0.9
        opacity: root.visible ? 1.0 : 0.0
        Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

        WifiMenu {
            anchors.fill: parent
            anchors.margins: 10
        }
    }
}
