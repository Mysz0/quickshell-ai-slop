import QtQuick
import "./bar"
import "./dashboard"
import "./theme"

QtObject {
    // 1. The Bar
    property var topBar: TopBar {}

    // 2. The Dashboard (Classic View)
    property var dashboard: ControlCenter {}
    
    // 3. Independent Popups
    property var volumePopup: VolumePopup {}
    property var wifiPopup: WifiPopup {}
    property var btPopup: BluetoothPopup {}
}
