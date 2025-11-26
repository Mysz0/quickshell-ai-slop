// theme/Style.qml
pragma Singleton
import QtQuick

QtObject {
    property color background: "#CC1e1e2e" // Dark with transparency
    property color surface: "#313244"
    property color highlight: "#89b4fa"
    property color text: "#cdd6f4"
    property color urgent: "#f38ba8"

    property int cornerRadius: 12
    property int spacing: 8
}
