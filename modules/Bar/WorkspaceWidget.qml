import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import qs.config as Config

RowLayout {
    id: root
    implicitHeight: Config.BarConfig.height
    property var workspaceCountGreaterThan10: Hyprland.workspaces.values.filter(ws => isUnnamed(ws)).length
    property int workspaceCount: workspaceCountGreaterThan10 + 10

    Repeater {

        model: root.workspaceCount //(10 /* + workspaceCountGreaterThan10*/)
        //onItemAdded: console.log(workspaceCount)

        Rectangle {
            id: rectangle
            required property var index
            property var workspaceCountGreaterThan10: Hyprland.workspaces.values.filter(ws => isUnnamed(ws)).length
            property var workspaceGreaterThan10: Hyprland.workspaces.values.filter(ws => isUnnamed(ws))

            Layout.maximumWidth: 28
            Layout.minimumWidth: 28
            Layout.preferredHeight: parent.height
            color: "transparent"
            // This is the workspace only if it actually has a window in it.
            property var workspace: index > 9 ? workspaceGreaterThan10[index - 10] : Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
            // This checks if the workspace is the active one.
            property bool isActive: index > 9 ? Hyprland.focusedWorkspace?.id == workspaceGreaterThan10[index - 10].id : Hyprland.focusedWorkspace?.id === (index + 1)
            // TODO make this variable replace the workspace variable as it is only used here
            // This bool is based on whether the workspace is null or not. Could probably replace workspace.
            property bool hasWindows: workspace !== null
            function getWorkspaceNumber() {
                if (index > 9) {
                    return index;
                } else if (index == 10) {}
            }
            Text {
                id: text
                text: rectangle.index > 9 ? rectangle.workspaceGreaterThan10[rectangle.index - 10].id : rectangle.index + 1
                color: parent.isActive ? Config.Theme.colPurple : (parent.hasWindows ? Config.Theme.colCyan : Config.Theme.colMuted)
                font.pixelSize: Config.Theme.fontSize
                font.family: Config.Theme.fontFamily
                font.bold: true
                anchors.centerIn: parent
            }

            Rectangle {
                width: 20
                height: 3
                color: parent.isActive ? Config.Theme.colPurple : Config.Theme.colBg
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.bottom
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent

                onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (rectangle.index > 9 ? rectangle.workspaceGreaterThan10[rectangle.index - 10].id : rectangle.index + 1) + " })")

                hoverEnabled: true

                onEntered: rectangle.color = Config.Theme.hoverDarken
                onExited: rectangle.color = "transparent"
            }

            function isUnnamed(workspace) {
                if (workspace.id > 10) {
                    return workspace;
                }
                return false;
            }
        }
    }
    function isUnnamed(workspace) {
        if (workspace.id > 10) {
            return workspace;
        }
        return false;
    }
}
