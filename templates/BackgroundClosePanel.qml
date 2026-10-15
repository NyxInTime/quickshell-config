// shove this in any panel that you want to close if clicked outside of

import Quickshell
import QtQuick

PanelWindow {
    id: root
    required property var popup
    exclusionMode: ExclusionMode.Ignore
    focusable: false
    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }
    visible: popup.visible
    color: "transparent"
    MouseArea {
        anchors.fill: parent
        onClicked: root.popup.visible = false
    }
}
