pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

QtObject {
    id: root

    // Reference to the bar for anchoring
    property var topBarWindow: null

    // Icon coordinates
    property int dashboardX: 0
    property int volumeX: 0
    property int wifiX: 0
    property int bluetoothX: 0

    // Central logic for exclusive popups
    property string activePopup: ""

    function togglePopup(name) {
        if (activePopup === name) {
            activePopup = ""
        } else {
            activePopup = name
        }
    }

    function closeAll() {
        activePopup = ""
    }

    // Helper properties for bindings
    readonly property bool showDashboard: activePopup === "dashboard"
    readonly property bool showVolume: activePopup === "volume"
    readonly property bool showWifi: activePopup === "wifi"
    readonly property bool showBluetooth: activePopup === "bluetooth"

    // Auto-close menu when clicking a window (Hyprland focus change)
    property var _monitorFocus: Hyprland.focusedWindow
    on_MonitorFocusChanged: closeAll()
}
