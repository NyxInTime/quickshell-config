import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick
import QtQuick.Controls
import qs.Types
import qs.modules.SettingsMenu

import qs.config as Config

Scope {
    id: root

    IpcHandler {
        target: "dashboard"
        function toggle(): void {
            dashboardPanel.visible = !dashboardPanel.visible;
        }
    }

    function toggle(): void {
        dashboardPanel.visible = !dashboardPanel.visible;
    }

    property string currentTab: "media"
    property int numButtons: 3
    PanelWindow {
        id: dashboardPanel
        visible: false
        exclusiveZone: 0
        //color: "transparent"
        implicitWidth: media.width + 50 // change this to not change and be a good width
        implicitHeight: media.height + 15 + tabBar.height
        anchors {
            top: true
        }
        /*PopupWindow {
            anchor.window: dashboardPanel
            anchor.rect.x: dashboardPanel.implicitWidth
            anchor.rect.y: -500
            width: rightCorner.widthVar
            height: rightCorner.heightVar
            visible: true
            color: "transparent"
            Corner {
                id: rightCorner
                widthVar: 100
                heightVar: 100
                controlXvar: 10
                controlYvar: 10
                cornerColor: "pink"//Config.Theme.colBg
            }
        }*/

        Rectangle {
            anchors.fill: parent
            color: Config.Theme.colBg
            bottomLeftRadius: 30
            bottomRightRadius: 30
            //radius: 30
            //topRightRadius: 30
        }

        Rectangle {
            id: tabBar
            width: parent.width
            height: 30
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"
            Rectangle {
                id: mediaButton
                color: root.currentTab == "media" ? Config.Theme.activeTab : Config.Theme.inactiveTab
                anchors.left: parent.left
                anchors.top: parent.top
                height: parent.height

                implicitWidth: parent.width / root.numButtons
                Text {
                    text: "media"
                    anchors.centerIn: parent
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.currentTab = "media"
                }
            }
            Rectangle {
                id: powerButton
                color: root.currentTab == "power" ? Config.Theme.activeTab : Config.Theme.inactiveTab
                anchors.left: mediaButton.right
                height: parent.height
                width: parent.width / root.numButtons
                Text {
                    text: "power"
                    anchors.centerIn: parent
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.currentTab = "power"
                }
            }
            Rectangle {
                id: settingsButton
                color: root.currentTab == "settings" ? Config.Theme.activeTab : Config.Theme.inactiveTab
                anchors.left: powerButton.right
                height: parent.height
                width: parent.width / root.numButtons
                Text {
                    text: "settings"
                    anchors.centerIn: parent
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.currentTab = "settings"
                }
            }
        }
        /*TabBar {
            id: tabBar
            implicitWidth: parent.width

            TabButton {
                //border.width: 0
                anchors.left: parent.left
                text: "media"
                id: mediaButton
            }
            TabButton {
                anchors.left: mediaButton.right
                text: "power"
                id: powerButton
            }


        }
        */
        Media {
            id: media
            visible: root.currentTab == "media"
            anchors.top: tabBar.bottom
            anchors.topMargin: 3
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.centerIn: parent
            //implicitHeight: 60

        }
        Power {
            id: power
            visible: root.currentTab == "power"
            anchors.top: tabBar.bottom
            anchors.topMargin: 3
            anchors.horizontalCenter: parent.horizontalCenter
        }
        QuickSettings {
            visible: root.currentTab == "settings"
            anchors.top: tabBar.bottom
            anchors.topMargin: 3
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height - tabBar.height
            width: parent.width - 60
        }
    }
}
