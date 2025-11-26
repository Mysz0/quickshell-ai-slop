import QtQuick
import "./bar"
import "./dashboard"
import "./theme"

QtObject {
    // 1. The Bar
    property var topBar: TopBar {}

    // 2. The Dashboard (Hidden by default, waits for button press)
    property var dashboard: ControlCenter {}
}
