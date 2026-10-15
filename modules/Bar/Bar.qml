import Quickshell
import QtQuick.Layouts
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Hyprland

import qs.config as Config
import "../Dashboard/"
//For testing
import qs.services as Services
import qs.Types

Scope {
    property bool dashboardOpen: false
    Variants {
        model: Quickshell.screens
        delegate: Component {

            PanelWindow {
                required property var modelData
                screen: modelData
                implicitHeight: 3
                anchors {
                    top: true
                    left: true
                    right: true
                }
                color: Config.Theme.colBg
            }
        }
    }

    Variants {
        model: Quickshell.screens
        delegate: Component {

            PanelWindow {
                required property var modelData
                screen: modelData
                visible: true
                color: "transparent"
                anchors {
                    top: true
                    left: true
                    right: true
                }

                Rectangle {
                    anchors.fill: parent

                    bottomLeftRadius: 5
                    bottomRightRadius: 5
                    color: Config.Theme.colBg
                }

                implicitHeight: Config.BarConfig.height

                WorkspaceWidget {
                    id: workspaces
                }

                BarSpacer {
                    id: betweenWorkspaceAndKeyboard
                    anchors.left: workspaces.right
                }

                Text {
                    color: "white"
                    anchors.left: betweenWorkspaceAndKeyboard.right
                    anchors.verticalCenter: workspaces.verticalCenter
                    text: Services.LayoutService.currentLayout
                }

                WindowTitle {
                    id: title
                }
                /*Text {
                    text: Hyprland
                    anchors.left: title.right
                }*/
                /*Rectangle {
            anchors.right: betweenDashAndPower.left
            width: 30
            height: parent.height
            color: "transparent"
            Text {
                anchors.centerIn: parent
                text: "⏻"
                color: "white"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: powerMenu()
            }
        }*/

                BarSpacer {
                    id: betweenDashAndPower
                    anchors.right: dash.left
                }

                Rectangle {
                    id: dash
                    anchors.right: betweenBatteryAndDash.left
                    width: dashText.width
                    height: 30
                    color: "transparent"
                    Text {
                        id: dashText
                        text: "Open Dashboard"
                        color: "white"
                    }
                    MouseArea {
                        anchors.fill: parent

                        onClicked: dashboard.toggle()
                        hoverEnabled: true
                        //For testing
                        onEntered: console.log(Services.MediaPlayer.players.length + " " + Services.MediaPlayer.players)
                    }
                }
                BarSpacer {
                    id: betweenBatteryAndDash
                    anchors.right: battery.left
                }
                BatteryWidget {
                    id: battery
                    anchors.right: betweenMediaAndBattery.left
                }

                BarSpacer {
                    id: betweenMediaAndBattery
                    anchors.right: clock.left
                }

                ClockWidget {
                    id: clock
                    anchors.right: rightSpacer.left
                    color: "white"
                }
                BarSpacer {
                    id: rightSpacer
                    anchors.right: parent.right
                    width: 5
                }
            }
        }
    }
    Dashboard {
        id: dashboard
    }
    function powerMenu() {
        Quickshell.execDetached({
            command: ["~/.config/nic4k/wlogout.sh"]
        });
    }
}
