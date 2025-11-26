import QtQuick
import "../theme"

Rectangle {
    id: root
    
    // Default dimensions (can be overridden)
    height: 30
    radius: 12

    // Standard styling
    color: Style.surface      // #313244
    border.width: 1
    border.color: "#45475a"   // Lighter border for contrast

    // Anti-aliasing for smooth rounded corners
    layer.enabled: true
    layer.samples: 4
}
