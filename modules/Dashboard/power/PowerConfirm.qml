import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Controls
import Quickshell.Wayland
import QtQuick.Layouts

import qs.config as Config
import qs.services as Services

PanelWindow {
    id: powerConfirmPanel

    //Keys.onEscapePressed: console.log("hi") //color = "white"//launcherPanel.visible =

    IpcHandler {
        target: "power"
        function toggle() {
            powerConfirmPanel.visible = !powerConfirmPanel.visible;
            /* Responsive power menu
            if (launcherPanel.visible) {
                powerInput.text = ""
                selectedIndex = 0
                powerInput.forceActiveFocus()
            }
            */
        }
    }
    visible: false
    focusable: true
    //focusable: false
    color: "transparent"

    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    // Dark overlay backdrop
    MouseArea {
        anchors.fill: parent
        // Add a mask of the power confirm box id
        onClicked: powerConfirmPanel.visible = false

        Rectangle {
            anchors.fill: parent
            color: Config.Theme.semiTransBackground //root.theme.bgOverlay
        }
    }

    // Centered launcher box
    Rectangle {
        // Trying to get responsive power menu
        /*TextInput {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: 200
            height: 50
            id: powerInput
            focus: true
            clip: true
            Keys.onEscapePressed: launcherPanel.visible = false
            Text {

            }
        }*/
        id: powerConfirmBox
        anchors.centerIn: parent
        width: 580
        height: 240
        radius: 16
        color: Config.Theme.bgBase //root.theme.bgBase
        border.color: Config.Theme.bgBorder //root.theme.bgBorder
        border.width: 1
        ColumnLayout {
            //anchors.fill: parent
            anchors.centerIn: parent
            width: 580
            height: 240
            RowLayout {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.bottomMargin: 5
                implicitHeight: parent.height / 2 - 10
                implicitWidth: 540
                Rectangle {
                    radius: 5
                    color: Config.Theme.colMuted
                    height: parent.height - 10
                    width: (parent.width / 3)
                    TextInput {
                        anchors.centerIn: parent
                        text: "hello hi please exist"
                        Layout.fillWidth: true
                        color: "white"
                    }
                    Text {
                        color: "white"
                        anchors.centerIn: parent
                        text: "hibernate"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: hibernate.running = true
                        hoverEnabled: true
                        onEntered: screenOff.running = true
                        onExited: screenOn.running = true
                    }
                    Process {
                        id: hibernate
                        command: ["sh", "-c", "systemctl hibernate"]
                        stdout: StdioCollector {
                            onStreamFinished: powerConfirmPanel.visible = false
                        }
                    }
                }
                Rectangle {
                    radius: 5
                    color: Config.Theme.colMuted
                    height: parent.height - 10
                    width: (parent.width / 3)
                    Text {
                        color: "white"
                        anchors.centerIn: parent
                        text: "logout"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: logout.running = true
                    }
                    Process {
                        id: logout
                        command: ["sh", "-c", "loginctl terminate-user $USER"]
                        stdout: StdioCollector {
                            onStreamFinished: powerConfirmPanel.visible = false
                        }
                    }
                }
                Rectangle {
                    radius: 5
                    color: Config.Theme.colMuted
                    height: parent.height - 10
                    width: (parent.width / 3)
                    Text {
                        color: "white"
                        anchors.centerIn: parent
                        text: "reboot"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: reboot.running = true
                    }
                    Process {
                        id: reboot
                        command: ["sh", "-c", "systemctl reboot"]
                        stdout: StdioCollector {
                            onStreamFinished: powerConfirmPanel.visible = false
                        }
                    }
                }
            }
            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.verticalCenter
                anchors.topMargin: 5
                implicitHeight: parent.height / 2 - 10
                width: 540
                Rectangle {
                    radius: 5
                    color: Config.Theme.colMuted
                    height: parent.height - 10
                    width: (parent.width / 3)
                    Text {
                        color: "white"
                        anchors.centerIn: parent
                        text: "Lock"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Services.Lock.locked = true
                    }
                    Process {
                        id: lock
                        command: ["sh", "-c", "loginctl lock-session"]
                        stdout: StdioCollector {
                            onStreamFinished: powerConfirmPanel.visible = false
                        }
                    }
                }
                Rectangle {
                    radius: 5
                    color: Config.Theme.colMuted
                    height: parent.height - 10
                    width: (parent.width / 3)
                    Text {
                        color: "white"
                        anchors.centerIn: parent
                        text: "Suspend"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: suspend.running = true
                    }
                    Process {
                        id: suspend
                        command: ["sh", "-c", "systemctl suspend"]
                        stdout: StdioCollector {
                            onStreamFinished: powerConfirmPanel.visible = false
                        }
                    }
                }
                Rectangle {
                    radius: 5
                    color: Config.Theme.colMuted
                    height: parent.height - 10
                    width: (parent.width / 3)
                    Text {
                        color: "white"
                        anchors.centerIn: parent
                        text: "Power off"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: powerOff.running = true
                    }
                    Process {
                        id: powerOff
                        command: ["systemctl", "poweroff"]
                        stdout: StdioCollector {
                            onStreamFinished: powerConfirmPanel.visible = false
                        }
                    }
                }
            }
        }
    }
}
